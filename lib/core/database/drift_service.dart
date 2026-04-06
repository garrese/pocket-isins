import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'drift/app_database.dart';

part 'drift_service.g.dart';

class DriftService {
  late final AppDatabase db;

  Future<void> init() async {
    try {
      db = AppDatabase();
      // Verify connection by doing a simple query
      await db.customSelect('SELECT 1').get();
    } catch (e, stackTrace) {
      print('Failed to initialize Drift database: $e\n$stackTrace');
      // Rethrow to allow the app to fail fast if DB is inaccessible
      rethrow;
    }
  }
}

@Riverpod(keepAlive: true)
DriftService driftService(Ref ref) {
  throw UnimplementedError('driftService must be overridden in main.dart');
}
