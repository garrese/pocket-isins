class DeveloperSettingsState {
  final bool debugLabelsEnabled;
  final bool showLogConsole;
  final bool logHttpBodies;

  const DeveloperSettingsState({
    required this.debugLabelsEnabled,
    required this.showLogConsole,
    required this.logHttpBodies,
  });

  DeveloperSettingsState copyWith({
    bool? debugLabelsEnabled,
    bool? showLogConsole,
    bool? logHttpBodies,
  }) {
    return DeveloperSettingsState(
      debugLabelsEnabled: debugLabelsEnabled ?? this.debugLabelsEnabled,
      showLogConsole: showLogConsole ?? this.showLogConsole,
      logHttpBodies: logHttpBodies ?? this.logHttpBodies,
    );
  }
}
