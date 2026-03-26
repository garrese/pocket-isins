import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/log/log_service.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'User-Agent': 'yaak',
        'Accept': '*/*',
      },
    ),
  );

  final log = ref.read(logServiceProvider.notifier);

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        log.debug('REQUEST [${options.method}] => PATH: ${options.uri}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        log.debug(
            'RESPONSE [${response.statusCode}] => PATH: ${response.requestOptions.uri}');
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        log.error(
            'ERROR [${e.response?.statusCode}] => PATH: ${e.requestOptions.uri}',
            e,
            e.stackTrace);
        return handler.next(e);
      },
    ),
  );

  return dio;
});
