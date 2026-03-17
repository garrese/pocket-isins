class AiSettings {
  final String apiProvider;
  final String baseUrl;
  final String apiKey;
  final String modelName;

  const AiSettings({
    this.apiProvider = 'openai',
    this.baseUrl = 'https://api.openai.com/v1',
    this.apiKey = '',
    this.modelName = 'gpt-4o',
  });

  AiSettings copyWith({
    String? apiProvider,
    String? baseUrl,
    String? apiKey,
    String? modelName,
  }) {
    return AiSettings(
      apiProvider: apiProvider ?? this.apiProvider,
      baseUrl: baseUrl ?? this.baseUrl,
      apiKey: apiKey ?? this.apiKey,
      modelName: modelName ?? this.modelName,
    );
  }
}
