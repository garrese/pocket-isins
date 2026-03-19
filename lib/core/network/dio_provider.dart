import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A Riverpod provider that returns a shared [Dio] instance for the entire application.
/// Reusing a single [Dio] instance is more efficient as it manages a connection pool
/// and reduces the overhead of constant instantiation and configuration.
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();

  // Set global defaults if any, but specific headers should be passed per request
  // via Options to avoid side effects on other parts of the app using this shared instance.
  dio.options.connectTimeout = const Duration(seconds: 15);
  dio.options.receiveTimeout = const Duration(seconds: 15);

  return dio;
});
