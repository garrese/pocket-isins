import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'developer_settings_provider.g.dart';

@riverpod
class DeveloperSettings extends _$DeveloperSettings {
  static const _debugLabelsKey = 'debug_labels_enabled';

  @override
  bool build() {
    _loadSettings();
    return false; // Default value until loaded
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool(_debugLabelsKey) ?? false;
  }

  Future<void> setDebugLabelsEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_debugLabelsKey, value);
    state = value;
  }
}
