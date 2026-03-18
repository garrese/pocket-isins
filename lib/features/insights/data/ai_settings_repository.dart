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

  static const _keyBaseUrl = 'ai_base_url';
  static const _keyApiKey = 'ai_api_key';
  static const _keyModelName = 'ai_model_name';

  Future<AiSettings> getSettings() async {
    final baseUrl = await _storage.read(key: _keyBaseUrl);
    final apiKey = await _storage.read(key: _keyApiKey);
    final modelName = await _storage.read(key: _keyModelName);

    return AiSettings(
      baseUrl: baseUrl ?? 'https://api.openai.com/v1',
      apiKey: apiKey ?? '',
      modelName: modelName ?? 'gpt-4o',
    );
  }

  Future<void> saveSettings(AiSettings settings) async {
    await _storage.write(key: _keyBaseUrl, value: settings.baseUrl);
    await _storage.write(key: _keyApiKey, value: settings.apiKey);
    await _storage.write(key: _keyModelName, value: settings.modelName);
  }
}
