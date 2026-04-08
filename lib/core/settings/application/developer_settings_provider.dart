import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../domain/developer_settings_state.dart';
import '../../../core/services/log/talker_provider.dart';
import '../../services/log/custom_talker_formatter.dart';

part 'developer_settings_provider.g.dart';

@riverpod
class DeveloperSettings extends _$DeveloperSettings {
  static const _showLogConsoleKey = 'show_log_console';
  static const _enableLongLogDetailsKey = 'enable_long_log_details';
  static const _logLevelKey = 'log_level';
  static const _maxHistoryItemsKey = 'max_history_items';

  @override
  DeveloperSettingsState build() {
    _loadSettings();
    return const DeveloperSettingsState(
      showLogConsole: false,
      enableLongLogDetails: false,
      logLevel: LogLevel.info,
      maxHistoryItems: 30,
    );
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final logLevelIndex = prefs.getInt(_logLevelKey);
    final logLevel = logLevelIndex != null
        ? LogLevel.values.firstWhere(
            (e) => e.index == logLevelIndex,
            orElse: () => LogLevel.info,
          )
        : LogLevel.info;

    final enableLongLogDetails =
        prefs.getBool(_enableLongLogDetailsKey) ?? false;

    final maxHistoryItems = prefs.getInt(_maxHistoryItemsKey) ?? 30;

    // Apply log level to talker instance immediately if possible
    try {
      ref
          .read(talkerProvider)
          .configure(
            settings: TalkerSettings(
              useHistory: true,
              maxHistoryItems: maxHistoryItems,
              useConsoleLogs: true,
            ),
            logger: TalkerLogger(
              settings: TalkerLoggerSettings(
                level: logLevel,
                colors: {LogLevel.debug: AnsiPen()..green()},
              ),
              formatter: CustomTalkerFormatter(() => enableLongLogDetails),
            ),
          );
    } catch (_) {
      // Ignore if talkerProvider is not yet ready or accessible
    }

    state = DeveloperSettingsState(
      showLogConsole: prefs.getBool(_showLogConsoleKey) ?? false,
      enableLongLogDetails: enableLongLogDetails,
      logLevel: logLevel,
      maxHistoryItems: maxHistoryItems,
    );
  }

  Future<void> setShowLogConsole(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_showLogConsoleKey, value);
    state = state.copyWith(showLogConsole: value);
  }

  Future<void> setEnableLongLogDetails(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_enableLongLogDetailsKey, value);
    state = state.copyWith(enableLongLogDetails: value);

    try {
      ref
          .read(talkerProvider)
          .configure(
            settings: TalkerSettings(
              useHistory: true,
              maxHistoryItems: state.maxHistoryItems,
              useConsoleLogs: true,
            ),
            logger: TalkerLogger(
              settings: TalkerLoggerSettings(
                level: state.logLevel,
                colors: {LogLevel.debug: AnsiPen()..green()},
              ),
              formatter: CustomTalkerFormatter(() => value),
            ),
          );
    } catch (_) {}
  }

  Future<void> setLogLevel(LogLevel level) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_logLevelKey, level.index);

    try {
      ref
          .read(talkerProvider)
          .configure(
            settings: TalkerSettings(
              useHistory: true,
              maxHistoryItems: state.maxHistoryItems,
              useConsoleLogs: true,
            ),
            logger: TalkerLogger(
              settings: TalkerLoggerSettings(
                level: level,
                colors: {LogLevel.debug: AnsiPen()..green()},
              ),
              formatter: CustomTalkerFormatter(
                () => state.enableLongLogDetails,
              ),
            ),
          );
    } catch (_) {}

    state = state.copyWith(logLevel: level);
  }

  Future<void> setMaxHistoryItems(int items) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_maxHistoryItemsKey, items);

    try {
      ref
          .read(talkerProvider)
          .configure(
            settings: TalkerSettings(
              useHistory: true,
              maxHistoryItems: items,
              useConsoleLogs: true,
            ),
            logger: TalkerLogger(
              settings: TalkerLoggerSettings(
                level: state.logLevel,
                colors: {LogLevel.debug: AnsiPen()..green()},
              ),
              formatter: CustomTalkerFormatter(
                () => state.enableLongLogDetails,
              ),
            ),
          );
    } catch (_) {}

    state = state.copyWith(maxHistoryItems: items);
  }
}
