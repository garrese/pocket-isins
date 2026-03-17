import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/ai_settings.dart';
import '../domain/news_card_model.dart';
import 'ai_settings_repository.dart';

final dioProvider = Provider<Dio>((ref) {
  return Dio();
});

final aiServiceProvider = Provider<AiService>((ref) {
  return AiService(
    ref.watch(dioProvider),
    ref.watch(aiSettingsRepositoryProvider),
  );
});

class AiService {
  final Dio _dio;
  final AiSettingsRepository _settingsRepo;

  AiService(this._dio, this._settingsRepo);

  Future<List<NewsCardModel>> fetchMarketNews() async {
    final settings = await _settingsRepo.getSettings();

    const prompt = '''
You are a financial AI assistant. Your task is to search the internet for the most relevant and recent news about global stock markets, economy, or major financial events.

Return exactly 5 news items.
You must return the result STRICTLY as a JSON array of objects, with no markdown formatting, no code blocks, and no other text.

Example format:
[
  {
    "title": "News Title",
    "summary": "A brief 2-3 sentence summary of the news.",
    "url": "https://www.example-financial-news.com/article123",
    "source": "Bloomberg"
  }
]
''';

    if (settings.apiProvider == 'google_ai_studio') {
      return _fetchNewsGoogleAIStudio(settings, prompt);
    } else if (settings.apiProvider == 'openrouter_web') {
      return _fetchNewsOpenAICompatible(settings, prompt, openRouterWeb: true);
    } else {
      return _fetchNewsOpenAICompatible(settings, prompt);
    }
  }

  Future<List<NewsCardModel>> _fetchNewsGoogleAIStudio(
      AiSettings settings, String prompt) async {
    if (settings.apiKey.isEmpty) {
      throw Exception('API Key is missing for Google AI Studio.');
    }

    final headers = {
      'Content-Type': 'application/json',
    };

    var baseUrl = settings.baseUrl;
    if (baseUrl.endsWith('/')) {
      baseUrl = baseUrl.substring(0, baseUrl.length - 1);
    }
    // Expected default base url: https://generativelanguage.googleapis.com/v1beta
    final endpoint = '$baseUrl/models/${settings.modelName}:generateContent?key=${settings.apiKey}';

    final data = {
      'contents': [
        {
          'role': 'user',
          'parts': [
            {
              'text':
                  '$prompt\n\nFind the latest important stock market news.'
            }
          ]
        }
      ],
      'tools': [
        {'googleSearch': {}}
      ]
    };

    try {
      final response = await _dio.post(
        endpoint,
        options: Options(headers: headers),
        data: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final content = response.data['candidates'][0]['content']['parts'][0]['text'] as String;

        // Clean the string in case the model ignored instructions and wrapped in markdown
        final cleanedContent = content
            .replaceAll(RegExp(r'```json\n?'), '')
            .replaceAll(RegExp(r'```\n?'), '')
            .trim();

        final List<dynamic> jsonList = jsonDecode(cleanedContent);

        return jsonList.map((item) => NewsCardModel.fromJson(item)).toList();
      } else {
        throw Exception(
            'Failed to fetch news: ${response.statusCode} - ${response.data}');
      }
    } on DioException catch (e) {
      throw Exception(
          'Network or API Error: ${e.message}\n${e.response?.data}');
    } catch (error) {
      throw Exception('Parsing Error: $error');
    }
  }

  Future<List<NewsCardModel>> _fetchNewsOpenAICompatible(
      AiSettings settings, String prompt, {bool openRouterWeb = false}) async {
    if (settings.apiKey.isEmpty && settings.baseUrl.contains('openai.com')) {
      throw Exception('API Key is missing for OpenAI.');
    }

    final headers = {
      'Content-Type': 'application/json',
      if (settings.apiKey.isNotEmpty)
        'Authorization': 'Bearer ${settings.apiKey}',
      // OpenRouter specific headers recommended but not strictly required
      'HTTP-Referer': 'https://pocket-isins.app',
      'X-Title': 'Pocket ISINs',
    };

    final data = {
      'model': settings.modelName,
      'messages': [
        {
          'role': 'system',
          'content': prompt,
        },
        {
          'role': 'user',
          'content': 'Find the latest important stock market news.'
        }
      ],
      if (openRouterWeb)
        'plugins': [
          {'id': 'web'}
        ],
      // We enable generic tools/search if the model supports it natively via prompt,
      // or we just rely on models like gpt-4o which might search if asked.
      // Some APIs use specific parameters to force search, but since this is a "Universal Connector"
      // we stick to standard chat completions and instruct the model to use its tools.
    };

    // Make sure we append /chat/completions if the base url doesn't have it
    // Usually base url is something like https://api.openai.com/v1
    var endpoint = settings.baseUrl;
    if (!endpoint.endsWith('/chat/completions')) {
      if (endpoint.endsWith('/')) {
        endpoint += 'chat/completions';
      } else {
        endpoint += '/chat/completions';
      }
    }

    try {
      final response = await _dio.post(
        endpoint,
        options: Options(headers: headers),
        data: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final content =
            response.data['choices'][0]['message']['content'] as String;

        // Clean the string in case the model ignored instructions and wrapped in markdown
        final cleanedContent = content
            .replaceAll(RegExp(r'```json\n?'), '')
            .replaceAll(RegExp(r'```\n?'), '')
            .trim();

        final List<dynamic> jsonList = jsonDecode(cleanedContent);

        return jsonList.map((item) => NewsCardModel.fromJson(item)).toList();
      } else {
        throw Exception(
            'Failed to fetch news: ${response.statusCode} - ${response.data}');
      }
    } on DioException catch (e) {
      throw Exception(
          'Network or API Error: ${e.message}\n${e.response?.data}');
    } catch (error) {
      throw Exception('Parsing Error: $error');
    }
  }
}
