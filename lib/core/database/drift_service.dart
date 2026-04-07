import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data_import_service.dart';
import 'drift/app_database.dart';

part 'drift_service.g.dart';

class DriftService {
  late final AppDatabase db;

  Future<void> init() async {
    try {
      db = AppDatabase();
      // Verify connection by doing a simple query
      await db.customSelect('SELECT 1').get();

      // Seed default app data on first launch
      await _seedInitialData();
    } catch (e, stackTrace) {
      print('Failed to initialize Drift database: $e\n$stackTrace');
      // Rethrow to allow the app to fail fast if DB is inaccessible
      rethrow;
    }
  }

  Future<void> _seedInitialData() async {
    final prefs = await SharedPreferences.getInstance();
    final hasRunSeed = prefs.getBool('has_run_initial_seed') ?? false;

    if (!hasRunSeed) {
      try {
        final jsonString =
            await rootBundle.loadString('assets/init_dummy_app_data.json');
        await DataImportService.importFromJsonString(
          jsonString: jsonString,
          db: db,
          aiRepository: null, // Initial seed doesn't necessarily need the full Ref scope
        );
        await prefs.setBool('has_run_initial_seed', true);
        print('Initial dummy app data successfully seeded.');
      } catch (e, stack) {
        print('Failed to seed initial dummy app data: $e\n$stack');
      }
    }
  }
}

@Riverpod(keepAlive: true)
DriftService driftService(Ref ref) {
  throw UnimplementedError('driftService must be overridden in main.dart');
}
