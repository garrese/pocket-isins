import 'package:talker_flutter/talker_flutter.dart';

class DeveloperSettingsState {
  final bool debugLabelsEnabled;
  final bool showLogConsole;
  final bool logHttpBodies;
  final LogLevel logLevel;

  const DeveloperSettingsState({
    required this.debugLabelsEnabled,
    required this.showLogConsole,
    required this.logHttpBodies,
    required this.logLevel,
  });

  DeveloperSettingsState copyWith({
    bool? debugLabelsEnabled,
    bool? showLogConsole,
    bool? logHttpBodies,
    LogLevel? logLevel,
  }) {
    return DeveloperSettingsState(
      debugLabelsEnabled: debugLabelsEnabled ?? this.debugLabelsEnabled,
      showLogConsole: showLogConsole ?? this.showLogConsole,
      logHttpBodies: logHttpBodies ?? this.logHttpBodies,
      logLevel: logLevel ?? this.logLevel,
    );
  }
}
