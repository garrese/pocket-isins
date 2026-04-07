import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dio_provider.dart';
import '../../../core/services/log/app_logger.dart';
import '../../../core/services/log/talker_provider.dart';

final marketDataServiceProvider = Provider<MarketDataService>((ref) {
  return MarketDataService(ref.watch(dioProvider), ref.watch(appLoggerProvider));
});

class MarketDataService {
  final Dio _dio;
  final AppLogger _log;

  MarketDataService(this._dio, this._log);

  Future<Map<String, dynamic>?> fetchTickerData(String symbol) async {
    try {
      final url =
          'https://query2.finance.yahoo.com/v8/finance/chart/$symbol?interval=1d&range=1d';
      _log.info(
        'Fetching ticker data for $symbol (interval=1d, range=1d)\nURL: $url',
      );
      final response = await _dio.get(url);
      _log.debug('Response for $symbol:\n${response.data}');

      if (response.statusCode == 200) {
        final result = response.data['chart']['result']?[0];
        if (result != null) {
          return result;
        }
      }
      _log.warning(
        'No data found for $symbol',
        'Status code: ${response.statusCode}',
      );
      return null;
    } catch (e, stackTrace) {
      _log.handle(e, stackTrace, 'Failed to fetch data for $symbol');
      return null;
    }
  }

  Future<Map<String, dynamic>?> fetchHistoricalData(
    String symbol,
    String interval,
    String range,
  ) async {
    try {
      final url =
          'https://query2.finance.yahoo.com/v8/finance/chart/$symbol?interval=$interval&range=$range';
      _log.info(
        'Fetching historical data for $symbol (interval=$interval, range=$range)\nURL: $url',
      );
      final response = await _dio.get(url);
      _log.debug('Historical response for $symbol:\n${response.data}');

      if (response.statusCode == 200) {
        final result = response.data['chart']['result']?[0];
        if (result != null) {
          return result;
        }
      }
      _log.warning(
        'No historical data found for $symbol',
        'Status code: ${response.statusCode}',
      );
      return null;
    } catch (e, stackTrace) {
      _log.handle(e, stackTrace, 'Failed to fetch historical data for $symbol');
      return null;
    }
  }

  Future<Map<String, dynamic>?> fetchIntradayData(String symbol) async {
    try {
      final url =
          'https://query2.finance.yahoo.com/v8/finance/chart/$symbol?interval=5m&range=1d';
      _log.info(
        'Fetching intraday data for $symbol (interval=5m, range=1d)\nURL: $url',
      );
      final response = await _dio.get(url);
      _log.debug('Intraday response for $symbol:\n${response.data}');

      if (response.statusCode == 200) {
        final result = response.data['chart']['result']?[0];
        if (result != null) {
          return result;
        }
      }
      _log.warning(
        'No intraday data found for $symbol',
        'Status code: ${response.statusCode}',
      );
      return null;
    } catch (e, stackTrace) {
      _log.handle(e, stackTrace, 'Failed to fetch intraday data for $symbol');
      return null;
    }
  }

  Future<List<dynamic>> searchSymbol(String query) async {
    try {
      final url = 'https://query2.finance.yahoo.com/v1/finance/search';
      _log.info('Searching symbol for query: $query\nURL: $url');
      final response = await _dio.get(
        url,
        queryParameters: {'newsCount': 0, 'q': query},
        options: Options(headers: {'User-Agent': 'yaak', 'Accept': '*/*'}),
      );
      _log.debug('Search response for $query:\n${response.data}');

      if (response.statusCode == 200) {
        final quotes = response.data['quotes'] as List<dynamic>? ?? [];
        return quotes;
      }

      _log.warning(
        'No search results found for query: $query',
        'Status code: ${response.statusCode}',
      );
      return [];
    } catch (e, stackTrace) {
      _log.handle(e, stackTrace, 'Failed to search symbol for $query');
      return [];
    }
  }
}
