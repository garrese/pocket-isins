import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dio_provider.dart';
import '../services/log/log_service.dart';

final marketDataServiceProvider = Provider<MarketDataService>((ref) {
  return MarketDataService(
    ref.watch(dioProvider),
    ref.watch(logServiceProvider.notifier),
  );
});

class MarketDataService {
  final Dio _dio;
  final LogService _log;

  MarketDataService(this._dio, this._log);

  Future<Map<String, dynamic>?> fetchTickerData(String symbol) async {
    try {
      final url = 'https://query2.finance.yahoo.com/v8/finance/chart/$symbol?interval=1d&range=1d';
      _log.info('Fetching ticker data for $symbol');
      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        final result = response.data['chart']['result']?[0];
        if (result != null) {
          _log.debug('Data received for $symbol');
          return result;
        }
      }
      _log.warning('No data found for $symbol', 'Status code: \${response.statusCode}');
      return null;
    } catch (e, stackTrace) {
      _log.error('Failed to fetch data for $symbol', e, stackTrace);
      return null;
    }
  }

  Future<Map<String, dynamic>?> fetchHistoricalData(String symbol, String interval, String range) async {
    try {
      final url = 'https://query2.finance.yahoo.com/v8/finance/chart/$symbol?interval=$interval&range=$range';
      _log.info('Fetching historical data for $symbol (range $range)');
      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        final result = response.data['chart']['result']?[0];
        if (result != null) {
           _log.debug('Historical data received for $symbol');
          return result;
        }
      }
      _log.warning('No historical data found for $symbol', 'Status code: \${response.statusCode}');
      return null;
    } catch (e, stackTrace) {
      _log.error('Failed to fetch historical data for $symbol', e, stackTrace);
      return null;
    }
  }

  Future<Map<String, dynamic>?> fetchIntradayData(String symbol) async {
    try {
      final url = 'https://query2.finance.yahoo.com/v8/finance/chart/$symbol?interval=5m&range=1d';
      _log.info('Fetching intraday data for $symbol');
      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        final result = response.data['chart']['result']?[0];
        if (result != null) {
          _log.debug('Intraday data received for $symbol');
          return result;
        }
      }
      _log.warning('No intraday data found for $symbol', 'Status code: \${response.statusCode}');
      return null;
    } catch (e, stackTrace) {
      _log.error('Failed to fetch intraday data for $symbol', e, stackTrace);
      return null;
    }
  }
}
