class AiSettings {
  final String baseUrl;
  final String apiKey;
  final String modelName;

  const AiSettings({
    this.baseUrl = 'https://api.openai.com/v1',
    this.apiKey = '',
    this.modelName = 'gpt-4o',
  });

  AiSettings copyWith({
    String? baseUrl,
    String? apiKey,
    String? modelName,
  }) {
    return AiSettings(
      baseUrl: baseUrl ?? this.baseUrl,
      apiKey: apiKey ?? this.apiKey,
      modelName: modelName ?? this.modelName,
    );
  }
}
