class DeveloperSettingsState {
  final bool debugLabelsEnabled;
  final bool showLogConsole;
  final int logLevel; // 0: VERBOSE, 1: DEBUG, 2: INFO, 3: WARNING, 4: ERROR

  const DeveloperSettingsState({
    required this.debugLabelsEnabled,
    required this.showLogConsole,
    required this.logLevel,
  });

  DeveloperSettingsState copyWith({
    bool? debugLabelsEnabled,
    bool? showLogConsole,
    int? logLevel,
  }) {
    return DeveloperSettingsState(
      debugLabelsEnabled: debugLabelsEnabled ?? this.debugLabelsEnabled,
      showLogConsole: showLogConsole ?? this.showLogConsole,
      logLevel: logLevel ?? this.logLevel,
    );
  }
}
