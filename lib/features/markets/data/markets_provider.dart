import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/database/isar_service.dart';
import '../../../core/database/models/isin.dart';
import '../../../core/database/models/market_data_cache.dart';
import '../../../core/network/market_data_service.dart';

part 'markets_provider.g.dart';

@riverpod
class Markets extends _$Markets {
  @override
  Future<List<Isin>> build() async {
    return _fetchAndSyncIntradayData();
  }

  Future<List<Isin>> _fetchAndSyncIntradayData() async {
    final isar = ref.read(isarServiceProvider).db;
    final marketService = ref.read(marketDataServiceProvider);

    // Get all ISINs with their tickers loaded
    final isins = await isar.isins.where().findAll();
    for (var isin in isins) {
      await isin.tickers.load();
    }

    // Now check the cache for every ticker
    final now = DateTime.now();
    
    for (var isin in isins) {
      for (var ticker in isin.tickers) {
        await ticker.marketDataCache.load();

        bool needsUpdate = false;
        if (ticker.marketDataCache.value == null) {
          needsUpdate = true;
        } else {
          final cached = ticker.marketDataCache.value!;
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
                final fallbackData = await marketService.fetchHistoricalData(ticker.symbol, '1d', '1mo');
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
                final regularMarketPrice = (meta['regularMarketPrice'] as num).toDouble();
                final chartPreviousClose = (meta['chartPreviousClose'] as num?)?.toDouble() ?? regularMarketPrice;

                final List<double> intradayPrices = [];
                final closeArray = indicators['close'] as List<dynamic>? ?? [];
                for (final val in closeArray) {
                  if (val != null) intradayPrices.add((val as num).toDouble());
                }

                // Save to Isar
                await isar.writeTxn(() async {
                  MarketDataCache cache = ticker.marketDataCache.value ?? MarketDataCache();
                  cache.symbol = ticker.symbol;
                  cache.lastUpdated = now;
                  cache.regularMarketPrice = regularMarketPrice;
                  cache.chartPreviousClose = chartPreviousClose;
                  cache.intradayPrices = intradayPrices;
                  await isar.marketDataCaches.put(cache);
                  if (ticker.marketDataCache.value == null) {
                    ticker.marketDataCache.value = cache;
                    await ticker.marketDataCache.save();
                  }
                });
              }
            }
          } catch (e, stack) {
            debugPrint('MarketsProvider Error parsing data for ${ticker.symbol}: $e\n$stack');
            rethrow;
          }
        }
      }
    }

    return isins;
  }

  /// Clears all market data caches and forces a fresh fetch from Yahoo.
  Future<void> forceRefresh() async {
    final isar = ref.read(isarServiceProvider).db;
    // Clear all cached market data so everything gets re-fetched
    await isar.writeTxn(() => isar.marketDataCaches.clear());
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchAndSyncIntradayData);
  }
}
