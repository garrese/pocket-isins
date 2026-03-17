import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'market_data_service.g.dart';

class MarketDataService {
  final Dio _dio;

  MarketDataService() : _dio = Dio() {
    _dio.options.baseUrl = 'https://query1.finance.yahoo.com/v8/finance/chart/';
    _dio.options.headers = {
      'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'
    };
    // Allow 404 and other status codes without throwing exception to avoid crashing the state
    _dio.options.validateStatus = (status) => status != null && status < 500;
  }

  /// Fetches Level 1 Quote and Level 2 Intraday data (5m interval, 1d range).
  Future<Map<String, dynamic>?> fetchIntradayData(String symbol) async {
    return _fetch(symbol, '5m', '1d');
  }

  Future<Map<String, dynamic>?> _fetch(String symbol, String interval, String range) async {
    try {
      final response = await _dio.get(symbol, queryParameters: {
        'interval': interval,
        'range': range,
      });
      if (response.statusCode == 200) return response.data;
    } catch (e) {
      print('MarketDataService Error fetching $symbol: $e');
    }
    return null;
  }
}


@riverpod
MarketDataService marketDataService(Ref ref) {
  return MarketDataService();
}
