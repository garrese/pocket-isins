import 'package:talker_flutter/talker_flutter.dart';

class DeveloperSettingsState {
  final bool showLogConsole;
  final bool enableLongLogDetails;
  final LogLevel logLevel;
  final int maxHistoryItems;

  const DeveloperSettingsState({
    required this.showLogConsole,
    required this.enableLongLogDetails,
    required this.logLevel,
    required this.maxHistoryItems,
  });

  DeveloperSettingsState copyWith({
    bool? showLogConsole,
    bool? enableLongLogDetails,
    LogLevel? logLevel,
    int? maxHistoryItems,
  }) {
    return DeveloperSettingsState(
      showLogConsole: showLogConsole ?? this.showLogConsole,
      enableLongLogDetails: enableLongLogDetails ?? this.enableLongLogDetails,
      logLevel: logLevel ?? this.logLevel,
      maxHistoryItems: maxHistoryItems ?? this.maxHistoryItems,
    );
  }
}
