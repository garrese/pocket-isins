class AiSettings {
  final String apiProvider;
  final String baseUrl;
  final String apiKey;
  final String modelName;
  final bool webSearchCapability;

  const AiSettings({
    this.apiProvider = 'openai',
    this.baseUrl = 'https://api.openai.com/v1',
    this.apiKey = '',
    this.modelName = 'gpt-5.4-nano-2026-03-17',
    this.webSearchCapability = false,
  });

  AiSettings copyWith({
    String? apiProvider,
    String? baseUrl,
    String? apiKey,
    String? modelName,
    bool? webSearchCapability,
  }) {
    return AiSettings(
      apiProvider: apiProvider ?? this.apiProvider,
      baseUrl: baseUrl ?? this.baseUrl,
      apiKey: apiKey ?? this.apiKey,
      modelName: modelName ?? this.modelName,
      webSearchCapability: webSearchCapability ?? this.webSearchCapability,
    );
  }
}
