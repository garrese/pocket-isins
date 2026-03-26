import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import '../services/log/talker_provider.dart';
import '../settings/application/developer_settings_provider.dart';
import '../settings/domain/developer_settings_state.dart';

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

  final talker = ref.read(talkerProvider);
  final initialLogHttpBodies =
      ref.read(developerSettingsProvider).logHttpBodies;

  dio.interceptors.add(
    TalkerDioLogger(
      talker: talker,
      settings: TalkerDioLoggerSettings(
        printRequestHeaders: true,
        printResponseHeaders: false,
        printResponseMessage: true,
        printRequestData: initialLogHttpBodies,
        printResponseData: initialLogHttpBodies,
      ),
    ),
  );

  ref.listen<DeveloperSettingsState>(developerSettingsProvider, (prev, next) {
    if (prev?.logHttpBodies != next.logHttpBodies) {
      dio.interceptors.removeWhere((i) => i is TalkerDioLogger);
      dio.interceptors.add(
        TalkerDioLogger(
          talker: talker,
          settings: TalkerDioLoggerSettings(
            printRequestHeaders: true,
            printResponseHeaders: false,
            printResponseMessage: true,
            printRequestData: next.logHttpBodies,
            printResponseData: next.logHttpBodies,
          ),
        ),
      );
    }
  });

  return dio;
});
