import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/database/drift_service.dart';
import '../../../core/database/drift/app_database.dart' as drift;

import '../../../core/database/models/isin.dart';
import '../../../core/database/models/market_data_cache.dart';
import '../../../core/network/market_data_service.dart';
import '../../portfolio/data/portfolio_provider.dart';

part 'markets_provider.g.dart';

@Riverpod(keepAlive: true)
class Markets extends _$Markets {
  @override
  Future<List<Isin>> build() async {
    // 1. Fetch initial state from DB without waiting for network updates
    final isins = await _loadFromDb();

    // 2. Trigger async refresh for outdated tickers
    // We don't await this so the UI renders immediately with cached data
    _triggerBackgroundUpdates(isins);

    return isins;
  }

  Future<List<Isin>> _loadFromDb() async {
    final db = ref.read(driftServiceProvider).db;
    final isins = await ref.read(portfolioProvider.future);

    // Create a new list of Isin to avoid modifying the portfolioProvider state directly
    final List<Isin> localIsins = [];

    for (var originalIsin in isins) {
      final isin = Isin(
        id: originalIsin.id,
        isinCode: originalIsin.isinCode,
        altName: originalIsin.altName,
        registeredNames: originalIsin.registeredNames,
        shortName: originalIsin.shortName,
        tickers: [],
      );

      for (var ticker in originalIsin.tickers) {
        final cacheRow = await (db.select(
          db.marketDataCaches,
        )..where((c) => c.tickerId.equals(ticker.id)))
            .getSingleOrNull();

        final localTicker = ticker; // Ticker is mutated with cache below

        if (cacheRow != null) {
          localTicker.marketDataCache = MarketDataCache(
            id: cacheRow.id,
            symbol: cacheRow.symbol,
            lastUpdated: cacheRow.lastUpdated,
            regularMarketPrice: cacheRow.regularMarketPrice,
            chartPreviousClose: cacheRow.chartPreviousClose,
            intradayPrices: cacheRow.intradayPrices,
            intradayTimestamps: cacheRow.intradayTimestamps,
            regularMarketStart: cacheRow.regularMarketStart,
            regularMarketEnd: cacheRow.regularMarketEnd,
            preMarketStart: cacheRow.preMarketStart,
            preMarketEnd: cacheRow.preMarketEnd,
            postMarketStart: cacheRow.postMarketStart,
            postMarketEnd: cacheRow.postMarketEnd,
            ticker: localTicker,
          );
        }
        isin.tickers.add(localTicker);
      }
      localIsins.add(isin);
    }

    return localIsins;
  }

  void _triggerBackgroundUpdates(List<Isin> currentIsins) {
    final now = DateTime.now();
    for (var isin in currentIsins) {
      for (var ticker in isin.tickers) {
        bool needsUpdate = false;
        if (ticker.marketDataCache == null) {
          needsUpdate = true;
        } else {
          final cached = ticker.marketDataCache!;
          if (now.difference(cached.lastUpdated).inMinutes >= 5) {
            needsUpdate = true;
          }
        }

        if (needsUpdate) {
          _updateTickerData(ticker);
        }
      }
    }
  }

  Future<void> _updateTickerData(dynamic ticker) async {
    final db = ref.read(driftServiceProvider).db;
    final marketService = ref.read(marketDataServiceProvider);
    final now = DateTime.now();

    try {
      // Fetch from Yahoo (5m intraday)
      var rawData = await marketService.fetchIntradayData(ticker.symbol);

      if (rawData != null) {
        final indicators = rawData['indicators']?['quote']?[0];
        final closeArray = indicators?['close'] as List<dynamic>? ?? [];

        if (closeArray.isEmpty) {
          final fallbackData = await marketService.fetchHistoricalData(
            ticker.symbol,
            '1d',
            '1mo',
          );
          if (fallbackData != null) {
            rawData = fallbackData;
          }
        }
      }

      if (rawData != null) {
        final meta = rawData['meta'];
        final indicators = rawData['indicators']?['quote']?[0];

        if (meta != null && indicators != null) {
          final regularMarketPrice =
              (meta['regularMarketPrice'] as num).toDouble();
          final chartPreviousClose =
              (meta['chartPreviousClose'] as num?)?.toDouble() ??
                  regularMarketPrice;

          final List<double> intradayPrices = [];
          final List<int> intradayTimestamps = [];
          final closeArray = indicators['close'] as List<dynamic>? ?? [];
          final timestampArray =
              rawData['timestamp'] as List<dynamic>? ?? [];

          for (var i = 0; i < closeArray.length; i++) {
            final val = closeArray[i];
            if (val != null) {
              intradayPrices.add((val as num).toDouble());
              if (i < timestampArray.length) {
                intradayTimestamps.add(
                  (timestampArray[i] as num).toInt(),
                );
              } else {
                intradayTimestamps.add(0);
              }
            }
          }

          int? regStart;
          int? regEnd;
          int? preStart;
          int? preEnd;
          int? postStart;
          int? postEnd;

          final currentPeriod = meta['currentTradingPeriod'];
          if (currentPeriod != null) {
            regStart = currentPeriod['regular']?['start'] as int?;
            regEnd = currentPeriod['regular']?['end'] as int?;
            preStart = currentPeriod['pre']?['start'] as int?;
            preEnd = currentPeriod['pre']?['end'] as int?;
            postStart = currentPeriod['post']?['start'] as int?;
            postEnd = currentPeriod['post']?['end'] as int?;
          }

          MarketDataCache? updatedCache;

          // Save to Drift
          await db.transaction(() async {
            if (ticker.marketDataCache != null) {
              await (db.update(db.marketDataCaches)
                    ..where(
                      (c) => c.id.equals(ticker.marketDataCache!.id),
                    ))
                  .write(
                drift.MarketDataCachesCompanion(
                  lastUpdated: Value(now),
                  regularMarketPrice: Value(regularMarketPrice),
                  chartPreviousClose: Value(chartPreviousClose),
                  intradayPrices: Value(intradayPrices),
                  intradayTimestamps: Value(intradayTimestamps),
                  regularMarketStart: Value(regStart),
                  regularMarketEnd: Value(regEnd),
                  preMarketStart: Value(preStart),
                  preMarketEnd: Value(preEnd),
                  postMarketStart: Value(postStart),
                  postMarketEnd: Value(postEnd),
                ),
              );
              ticker.marketDataCache!.lastUpdated = now;
              ticker.marketDataCache!.regularMarketPrice =
                  regularMarketPrice;
              ticker.marketDataCache!.chartPreviousClose =
                  chartPreviousClose;
              ticker.marketDataCache!.intradayPrices = intradayPrices;
              ticker.marketDataCache!.intradayTimestamps =
                  intradayTimestamps;
              ticker.marketDataCache!.regularMarketStart = regStart;
              ticker.marketDataCache!.regularMarketEnd = regEnd;
              ticker.marketDataCache!.preMarketStart = preStart;
              ticker.marketDataCache!.preMarketEnd = preEnd;
              ticker.marketDataCache!.postMarketStart = postStart;
              ticker.marketDataCache!.postMarketEnd = postEnd;
              updatedCache = ticker.marketDataCache;
            } else {
              final newId = await db.into(db.marketDataCaches).insert(
                    drift.MarketDataCachesCompanion.insert(
                      symbol: ticker.symbol,
                      lastUpdated: now,
                      regularMarketPrice: Value(regularMarketPrice),
                      chartPreviousClose: Value(chartPreviousClose),
                      intradayPrices: Value(intradayPrices),
                      intradayTimestamps: Value(intradayTimestamps),
                      regularMarketStart: Value(regStart),
                      regularMarketEnd: Value(regEnd),
                      preMarketStart: Value(preStart),
                      preMarketEnd: Value(preEnd),
                      postMarketStart: Value(postStart),
                      postMarketEnd: Value(postEnd),
                      tickerId: ticker.id,
                    ),
                  );

              updatedCache = MarketDataCache(
                id: newId,
                symbol: ticker.symbol,
                lastUpdated: now,
                regularMarketPrice: regularMarketPrice,
                chartPreviousClose: chartPreviousClose,
                intradayPrices: intradayPrices,
                intradayTimestamps: intradayTimestamps,
                regularMarketStart: regStart,
                regularMarketEnd: regEnd,
                preMarketStart: preStart,
                preMarketEnd: preEnd,
                postMarketStart: postStart,
                postMarketEnd: postEnd,
                ticker: ticker,
              );
              ticker.marketDataCache = updatedCache;
            }
          });

          // After saving to DB, update the state of the provider to reflect changes in UI
          if (state.hasValue && state.value != null) {
            final currentState = state.value!;
            // We just trigger a state reassignment so the UI rerenders with the modified objects.
            state = AsyncData([...currentState]);
          }
        }
      }
    } catch (e, stack) {
      debugPrint(
        'MarketsProvider Error parsing data for ${ticker.symbol}: $e\n$stack',
      );
      // We don't rethrow here so that a single ticker failure doesn't crash everything,
      // it just won't update its cache.
    }
  }

  /// Forces a refresh by updating all tickers in the background
  Future<void> forceRefresh() async {
    if (!state.hasValue || state.value == null) return;

    // Just trigger updates for all tickers ignoring cache rules
    final currentIsins = state.value!;
    for (var isin in currentIsins) {
      for (var ticker in isin.tickers) {
        _updateTickerData(ticker);
      }
    }
  }
}
