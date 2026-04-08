import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/constrained_width.dart';
import '../data/ai_settings_repository.dart';
import '../domain/ai_settings.dart';
import 'package:pocket_isins/core/utils/toast_utils.dart';

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
  bool _webSearchCapability = false;
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
      webSearchCapability: _webSearchCapability,
    );

    try {
      final repo = ref.read(aiSettingsRepositoryProvider);
      await repo.saveSettings(newSettings);

      // Invalidate the provider so listeners get the new settings
      ref.invalidate(aiSettingsProvider);

      if (mounted) {
        ToastUtils.show(context, 'Settings saved successfully!');
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ToastUtils.show(context, 'Error saving settings: \$e');
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
      appBar: AppBar(title: const Text('BYOK AI Configuration')),
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
            _webSearchCapability = settings.webSearchCapability;
          }

          return ConstrainedWidth.narrow(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Configure your "Bring Your Own Key" (BYOK) AI provider.\n'
                      'Select the API Syntax below. If your provider uses standard OpenAI format (like Ollama, Groq, or basic OpenRouter), select "OpenAI Compatible". Only select a different syntax if it requires a proprietary format.',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedProvider,
                      decoration: const InputDecoration(
                        labelText: 'API Syntax',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'openai',
                          child: Text('OpenAI Compatible'),
                        ),
                        DropdownMenuItem(
                          value: 'openrouter_web',
                          child: Text('OpenRouter'),
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
                            if (value == 'openai') {
                              _baseUrlController.text =
                                  'https://api.openai.com/v1';
                              _modelNameController.text =
                                  'gpt-5.4-nano-2026-03-17';
                            } else if (value == 'openrouter_web') {
                              _baseUrlController.text =
                                  'https://openrouter.ai/api/v1';
                              _modelNameController.text = 'x-ai/grok-4.1-fast';
                            } else if (value == 'google_ai_studio') {
                              _baseUrlController.text =
                                  'https://generativelanguage.googleapis.com/v1beta';
                              _modelNameController.text =
                                  'gemini-3.1-flash-lite-preview';
                            }
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
                    CheckboxListTile(
                      title: const Text('Web Search Capability'),
                      subtitle: const Text(
                        'Enable web search during bot conversations (if supported by model)',
                      ),
                      value: _webSearchCapability,
                      onChanged: (bool? value) {
                        setState(() {
                          _webSearchCapability = value ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
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
                          : const Text(
                              'Save Configuration',
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) {
          debugPrint('ByokConfigScreen Error: $error');
          debugPrint('Stacktrace: $stack');
          return Center(child: Text('Error: $error'));
        },
      ),
    );
  }
}
