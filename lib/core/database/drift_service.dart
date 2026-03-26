import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'drift/app_database.dart';
import 'drift/connection/connection.dart' as impl;

final driftServiceProvider = Provider<DriftService>((ref) {
  // Should be overridden in main.dart after init
  throw UnimplementedError('driftServiceProvider not initialized');
});

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return ref.watch(driftServiceProvider).database;
});

class DriftService {
  late final AppDatabase database;

  Future<void> init() async {
    database = AppDatabase(impl.openConnection());
    // Note: LogService relies on Riverpod and is initialized later in main.dart
  }
}
