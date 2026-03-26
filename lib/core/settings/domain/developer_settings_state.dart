class DeveloperSettingsState {
  final bool debugLabelsEnabled;
  final bool showLogConsole;

  const DeveloperSettingsState({
    required this.debugLabelsEnabled,
    required this.showLogConsole,
  });

  DeveloperSettingsState copyWith({
    bool? debugLabelsEnabled,
    bool? showLogConsole,
  }) {
    return DeveloperSettingsState(
      debugLabelsEnabled: debugLabelsEnabled ?? this.debugLabelsEnabled,
      showLogConsole: showLogConsole ?? this.showLogConsole,
    );
  }
}
