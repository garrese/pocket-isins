import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/developer_settings_state.dart';

part 'developer_settings_provider.g.dart';

@riverpod
class DeveloperSettings extends _$DeveloperSettings {
  static const _debugLabelsKey = 'debug_labels_enabled';
  static const _showLogConsoleKey = 'show_log_console';
  static const _logLevelKey = 'log_level';

  @override
  DeveloperSettingsState build() {
    _loadSettings();
    return const DeveloperSettingsState(
      debugLabelsEnabled: false,
      showLogConsole: false,
      logLevel: 1, // Default to DEBUG
    );
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    state = DeveloperSettingsState(
      debugLabelsEnabled: prefs.getBool(_debugLabelsKey) ?? false,
      showLogConsole: prefs.getBool(_showLogConsoleKey) ?? false,
      logLevel: prefs.getInt(_logLevelKey) ?? 1,
    );
  }

  Future<void> setDebugLabelsEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_debugLabelsKey, value);
    state = state.copyWith(debugLabelsEnabled: value);
  }

  Future<void> setShowLogConsole(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_showLogConsoleKey, value);
    state = state.copyWith(showLogConsole: value);
  }

  Future<void> setLogLevel(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_logLevelKey, value);
    state = state.copyWith(logLevel: value);
  }
}
