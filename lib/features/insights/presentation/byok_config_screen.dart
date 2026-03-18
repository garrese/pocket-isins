import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/ai_settings_repository.dart';
import '../domain/ai_settings.dart';

final aiSettingsProvider = FutureProvider.autoDispose<AiSettings>((ref) async {
  final repo = ref.watch(aiSettingsRepositoryProvider);
  return repo.getSettings();
});

class ByokConfigScreen extends ConsumerStatefulWidget {
  const ByokConfigScreen({super.key});

  @override
  ConsumerState<ByokConfigScreen> createState() => _ByokConfigScreenState();
}

class _ByokConfigScreenState extends ConsumerState<ByokConfigScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _baseUrlController;
  late TextEditingController _apiKeyController;
  late TextEditingController _modelNameController;
  String _selectedProvider = 'openai';
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _baseUrlController = TextEditingController();
    _apiKeyController = TextEditingController();
    _modelNameController = TextEditingController();
  }

  @override
  void dispose() {
    _baseUrlController.dispose();
    _apiKeyController.dispose();
    _modelNameController.dispose();
    super.dispose();
  }

  Future<void> _saveSettings() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    final newSettings = AiSettings(
      apiProvider: _selectedProvider,
      baseUrl: _baseUrlController.text.trim(),
      apiKey: _apiKeyController.text.trim(),
      modelName: _modelNameController.text.trim(),
    );

    try {
      final repo = ref.read(aiSettingsRepositoryProvider);
      await repo.saveSettings(newSettings);

      // Invalidate the provider so listeners get the new settings
      ref.invalidate(aiSettingsProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Settings saved successfully!')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving settings: \$e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsyncValue = ref.watch(aiSettingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('BYOK AI Configuration'),
      ),
      body: settingsAsyncValue.when(
        data: (settings) {
          // Initialize controllers with current values
          if (_baseUrlController.text.isEmpty &&
              _apiKeyController.text.isEmpty &&
              _modelNameController.text.isEmpty) {
            _selectedProvider = settings.apiProvider;
            _baseUrlController.text = settings.baseUrl;
            _apiKeyController.text = settings.apiKey;
            _modelNameController.text = settings.modelName;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Configure your "Bring Your Own Key" (BYOK) AI provider. '
                    'Select your API Provider below. Supported: OpenAI-compatible APIs (OpenAI, OpenRouter, Ollama) and Google AI Studio.',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedProvider,
                    decoration: const InputDecoration(
                      labelText: 'API Provider',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'openai',
                        child: Text('OpenAI / Compatible (OpenRouter, etc.)'),
                      ),
                      DropdownMenuItem(
                        value: 'google_ai_studio',
                        child: Text('Google AI Studio (Gemini)'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedProvider = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _baseUrlController,
                    decoration: const InputDecoration(
                      labelText: 'Base URL',
                      hintText: 'e.g., https://api.openai.com/v1',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a Base URL';
                      }
                      if (!Uri.parse(value).isAbsolute) {
                        return 'Please enter a valid URL';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _modelNameController,
                    decoration: const InputDecoration(
                      labelText: 'Model Name',
                      hintText: 'e.g., gpt-4o',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a Model Name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _apiKeyController,
                    decoration: const InputDecoration(
                      labelText: 'API Key',
                      hintText: 'Enter your API Key',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    // API Key might be optional for some local setups like Ollama
                    // so we don't strictly validate it as mandatory, or we can just let the user leave it blank.
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _isSaving ? null : _saveSettings,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _isSaving
                        ? const CircularProgressIndicator()
                        : const Text('Save Configuration',
                            style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: \$error')),
      ),
    );
  }
}
