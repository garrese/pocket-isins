import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/ai_settings.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final aiSettingsRepositoryProvider = Provider<AiSettingsRepository>((ref) {
  return AiSettingsRepository(ref.watch(secureStorageProvider));
});

class AiSettingsRepository {
  final FlutterSecureStorage _storage;

  AiSettingsRepository(this._storage);

  static const _keyApiProvider = 'ai_api_provider';
  static const _keyBaseUrl = 'ai_base_url';
  static const _keyApiKey = 'ai_api_key';
  static const _keyModelName = 'ai_model_name';
  static const _keyWebSearchCapability = 'ai_web_search_capability';

  Future<AiSettings> getSettings() async {
    final apiProvider = await _storage.read(key: _keyApiProvider);
    final baseUrl = await _storage.read(key: _keyBaseUrl);
    final apiKey = await _storage.read(key: _keyApiKey);
    final modelName = await _storage.read(key: _keyModelName);
    final webSearchCapStr = await _storage.read(key: _keyWebSearchCapability);
    final webSearchCapability = webSearchCapStr == 'true';

    return AiSettings(
      apiProvider: apiProvider ?? 'openai',
      baseUrl: baseUrl ?? 'https://api.openai.com/v1',
      apiKey: apiKey ?? '',
      modelName: modelName ?? 'gpt-5.4-nano-2026-03-17',
      webSearchCapability: webSearchCapability,
    );
  }

  Future<void> saveSettings(AiSettings settings) async {
    await _storage.write(key: _keyApiProvider, value: settings.apiProvider);
    await _storage.write(key: _keyBaseUrl, value: settings.baseUrl);
    await _storage.write(key: _keyApiKey, value: settings.apiKey);
    await _storage.write(key: _keyModelName, value: settings.modelName);
    await _storage.write(
      key: _keyWebSearchCapability,
      value: settings.webSearchCapability.toString(),
    );
  }
}
