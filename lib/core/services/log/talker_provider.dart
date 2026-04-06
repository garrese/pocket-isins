import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'app_logger.dart';
import '../../settings/application/developer_settings_provider.dart';

final talkerProvider = Provider<Talker>((ref) {
  throw UnimplementedError(
    'talkerProvider must be overridden in ProviderScope',
  );
});

final appLoggerProvider = Provider<AppLogger>((ref) {
  final talker = ref.watch(talkerProvider);
  return AppLogger(
    talker,
    () => ref.read(developerSettingsProvider).enableLongLogDetails,
  );
});
