import 'package:talker_flutter/talker_flutter.dart';

class DeveloperSettingsState {
  final bool showLogConsole;
  final bool enableLongLogDetails;
  final LogLevel logLevel;

  const DeveloperSettingsState({
    required this.showLogConsole,
    required this.enableLongLogDetails,
    required this.logLevel,
  });

  DeveloperSettingsState copyWith({
    bool? showLogConsole,
    bool? enableLongLogDetails,
    LogLevel? logLevel,
  }) {
    return DeveloperSettingsState(
      showLogConsole: showLogConsole ?? this.showLogConsole,
      enableLongLogDetails: enableLongLogDetails ?? this.enableLongLogDetails,
      logLevel: logLevel ?? this.logLevel,
    );
  }
}
