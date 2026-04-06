import 'package:talker_flutter/talker_flutter.dart';

class DeveloperSettingsState {
  final bool debugLabelsEnabled;
  final bool showLogConsole;
  final bool enableLongLogDetails;
  final LogLevel logLevel;

  const DeveloperSettingsState({
    required this.debugLabelsEnabled,
    required this.showLogConsole,
    required this.enableLongLogDetails,
    required this.logLevel,
  });

  DeveloperSettingsState copyWith({
    bool? debugLabelsEnabled,
    bool? showLogConsole,
    bool? enableLongLogDetails,
    LogLevel? logLevel,
  }) {
    return DeveloperSettingsState(
      debugLabelsEnabled: debugLabelsEnabled ?? this.debugLabelsEnabled,
      showLogConsole: showLogConsole ?? this.showLogConsole,
      enableLongLogDetails: enableLongLogDetails ?? this.enableLongLogDetails,
      logLevel: logLevel ?? this.logLevel,
    );
  }
}
