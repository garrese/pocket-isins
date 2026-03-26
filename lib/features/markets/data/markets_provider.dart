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
    return _fetchAndSyncIntradayData();
  }

  Future<List<Isin>> _fetchAndSyncIntradayData() async {
    final db = ref.read(driftServiceProvider).db;
    final marketService = ref.read(marketDataServiceProvider);

    // Get all ISINs via Portfolio provider to ensure identical structure
    final isins = await ref.read(portfolioProvider.future);
    final now = DateTime.now();

    for (var isin in isins) {
      for (var ticker in isin.tickers) {
        final cacheRow = await (db.select(
          db.marketDataCaches,
        )..where((c) => c.tickerId.equals(ticker.id))).getSingleOrNull();

        if (cacheRow != null) {
          ticker.marketDataCache = MarketDataCache(
            id: cacheRow.id,
            symbol: cacheRow.symbol,
            lastUpdated: cacheRow.lastUpdated,
            regularMarketPrice: cacheRow.regularMarketPrice,
            chartPreviousClose: cacheRow.chartPreviousClose,
            intradayPrices: cacheRow.intradayPrices,
            intradayTimestamps: cacheRow.intradayTimestamps,
            ticker: ticker,
          );
        }

        bool needsUpdate = false;
        if (ticker.marketDataCache == null) {
          needsUpdate = true;
        } else {
          final cached = ticker.marketDataCache!;
          // If the cache is older than 5 minutes OR the price is 0 (corrupt data), we update
          final lastUpdate = cached.lastUpdated;
          if (now.difference(lastUpdate).inMinutes > 5) {
            needsUpdate = true;
          }
        }

        if (needsUpdate) {
          try {
            // Fetch from Yahoo (5m intraday)
            var rawData = await marketService.fetchIntradayData(ticker.symbol);

            // Fallback to 1d interval, 1mo range if intraday fetch doesn't have valid close indicators
            // (Some non-US exchanges don't provide 5m intraday data on Yahoo Finance)
            if (rawData != null && rawData['chart']?['result'] != null) {
              final result = rawData['chart']['result'][0];
              final indicators = result['indicators']?['quote']?[0];
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

            if (rawData != null && rawData['chart']?['result'] != null) {
              final result = rawData['chart']['result'][0];
              final meta = result['meta'];
              final indicators = result['indicators']?['quote']?[0];

              if (meta != null && indicators != null) {
                final regularMarketPrice = (meta['regularMarketPrice'] as num)
                    .toDouble();
                final chartPreviousClose =
                    (meta['chartPreviousClose'] as num?)?.toDouble() ??
                    regularMarketPrice;

                final List<double> intradayPrices = [];
                final List<int> intradayTimestamps = [];
                final closeArray = indicators['close'] as List<dynamic>? ?? [];
                final timestampArray =
                    result['timestamp'] as List<dynamic>? ?? [];

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

                // Save to Drift
                await db.transaction(() async {
                  if (ticker.marketDataCache != null) {
                    await (db.update(db.marketDataCaches)..where(
                          (c) => c.id.equals(ticker.marketDataCache!.id),
                        ))
                        .write(
                          drift.MarketDataCachesCompanion(
                            lastUpdated: Value(now),
                            regularMarketPrice: Value(regularMarketPrice),
                            chartPreviousClose: Value(chartPreviousClose),
                            intradayPrices: Value(intradayPrices),
                            intradayTimestamps: Value(intradayTimestamps),
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
                  } else {
                    final newId = await db
                        .into(db.marketDataCaches)
                        .insert(
                          drift.MarketDataCachesCompanion.insert(
                            symbol: ticker.symbol,
                            lastUpdated: now,
                            regularMarketPrice: Value(regularMarketPrice),
                            chartPreviousClose: Value(chartPreviousClose),
                            intradayPrices: Value(intradayPrices),
                            intradayTimestamps: Value(intradayTimestamps),
                            tickerId: ticker.id,
                          ),
                        );

                    ticker.marketDataCache = MarketDataCache(
                      id: newId,
                      symbol: ticker.symbol,
                      lastUpdated: now,
                      regularMarketPrice: regularMarketPrice,
                      chartPreviousClose: chartPreviousClose,
                      intradayPrices: intradayPrices,
                      intradayTimestamps: intradayTimestamps,
                      ticker: ticker,
                    );
                  }
                });
              }
            }
          } catch (e, stack) {
            debugPrint(
              'MarketsProvider Error parsing data for ${ticker.symbol}: $e\n$stack',
            );
            rethrow;
          }
        }
      }
    }

    return isins;
  }

  /// Clears all market data caches and forces a fresh fetch from Yahoo.
  Future<void> forceRefresh() async {
    final db = ref.read(driftServiceProvider).db;
    await db.delete(db.marketDataCaches).go();
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchAndSyncIntradayData);
  }
}
