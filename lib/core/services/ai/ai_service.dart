import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../network/dio_provider.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../../../core/services/log/talker_provider.dart';
import '../../../features/bot/domain/ai_settings.dart';
import '../../../features/bot/domain/news_card_model.dart';
import '../../../features/bot/data/ai_settings_repository.dart';

final aiServiceProvider = Provider<AiService>((ref) {
  return AiService(
    ref.watch(dioProvider),
    ref.watch(aiSettingsRepositoryProvider),
    ref.watch(talkerProvider),
  );
});

class AiService {
  final Dio _dio;
  final AiSettingsRepository _settingsRepo;
  final Talker _log;

  AiService(this._dio, this._settingsRepo, this._log);

  /// Helper to get generic response from AI provider
  Future<String> getGenericCompletion({
    required String systemPrompt,
    String? userPrompt,
    List<Map<String, String>>? messages,
    bool webSearch = false,
  }) async {
    final settings = await _settingsRepo.getSettings();

    final activeMessages = messages ??
        (userPrompt != null
            ? [
                {'role': 'user', 'content': userPrompt},
              ]
            : []);

    if (settings.apiProvider == 'google_ai_studio') {
      return _generateGoogleAIStudio(
        settings,
        systemPrompt,
        activeMessages,
        webSearch: webSearch,
      );
    } else {
      // By default use open ai compatible syntax (including OpenRouter)
      final useOpenRouterWeb =
          webSearch && settings.apiProvider == 'openrouter_web';
      return _generateOpenAICompatible(
        settings,
        systemPrompt,
        activeMessages,
        openRouterWeb: useOpenRouterWeb,
      );
    }
  }

  // Backwards compatibility for Insights feature
  Future<List<NewsCardModel>> fetchMarketNews() async {
    const systemPrompt = '''
You are a financial AI assistant. Your task is to search the internet for the most relevant and recent news about global stock markets, economy, or major financial events.

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

    const userPrompt = 'Find the latest important stock market news.';

    try {
      final content = await getGenericCompletion(
        systemPrompt: systemPrompt,
        userPrompt: userPrompt,
        webSearch: true,
      );

      final cleanedContent = content
          .replaceAll(RegExp(r'```json\n?'), '')
          .replaceAll(RegExp(r'```\n?'), '')
          .trim();

      _log.debug('AI News JSON parsed successfully');
      final List<dynamic> jsonList = jsonDecode(cleanedContent);
      return jsonList.map((item) => NewsCardModel.fromJson(item)).toList();
    } catch (e, stackTrace) {
      _log.handle(e, stackTrace, 'Failed to fetch market news');
      throw Exception('Failed to fetch market news: $e');
    }
  }

  // Feed rating feature (batch)
  Future<Map<int, int>> rateNewsRelevanceBatch(
    List<Map<String, dynamic>> newsBatch,
  ) async {
    const systemPrompt = '''
You are a financial AI assistant. Your task is to rate the relevance of the following news titles for a stock market investor.
You will be provided with a JSON array of news items, each containing an 'id' and a 'title'.
You must return the result STRICTLY as a JSON array of objects, with no markdown formatting, no code blocks, and no other text.
Each object in the array must contain the original 'id' (as an integer) and a 'rating' (as an integer from 1 to 10).

Example format:
[
  {
    "id": 123,
    "rating": 8
  },
  {
    "id": 124,
    "rating": 3
  }
]
''';

    final userPrompt = jsonEncode(newsBatch);

    try {
      final content = await getGenericCompletion(
        systemPrompt: systemPrompt,
        userPrompt: userPrompt,
        webSearch: false,
      );

      final cleanedContent = content
          .replaceAll(RegExp(r'```json\n?'), '')
          .replaceAll(RegExp(r'```\n?'), '')
          .trim();

      final List<dynamic> jsonList = jsonDecode(cleanedContent);
      final Map<int, int> results = {};

      for (final item in jsonList) {
        if (item is Map &&
            item.containsKey('id') &&
            item.containsKey('rating')) {
          final id = int.tryParse(item['id'].toString());
          final rating = int.tryParse(item['rating'].toString());
          if (id != null && rating != null) {
            results[id] = rating;
          }
        }
      }
      _log.debug('AI rating parsed successfully for ${results.length} items');
      return results;
    } catch (e) {
      _log.warning('AI rating failed, returning empty map', e);
      // Return empty map instead of crashing if rating fails
      return {};
    }
  }

  Future<String> _generateGoogleAIStudio(
    AiSettings settings,
    String systemPrompt,
    List<Map<String, String>> messages, {
    bool webSearch = false,
  }) async {
    if (settings.apiKey.isEmpty) {
      _log.warning('API Key is missing for Google AI Studio.');
      throw Exception('API Key is missing for Google AI Studio.');
    }

    final headers = {'Content-Type': 'application/json'};

    var baseUrl = settings.baseUrl;
    if (baseUrl.endsWith('/')) {
      baseUrl = baseUrl.substring(0, baseUrl.length - 1);
    }

    final endpoint =
        '$baseUrl/models/${settings.modelName}:generateContent?key=${settings.apiKey}';

    final data = {
      'systemInstruction': {
        'parts': [
          {'text': systemPrompt},
        ],
      },
      'contents': messages.map((m) {
        // Google AI Studio expects 'user' and 'model'
        final role = m['role'] == 'assistant' ? 'model' : 'user';
        return {
          'role': role,
          'parts': [
            {'text': m['content']},
          ],
        };
      }).toList(),
      if (webSearch)
        'tools': [
          {'googleSearch': {}},
        ],
    };

    try {
      final response = await _dio.post(
        endpoint,
        options: Options(headers: headers),
        data: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final reply = response.data['candidates'][0]['content']['parts'][0]
            ['text'] as String;
        return reply;
      } else {
        _log.handle(
          Exception('Failed completion Google'),
          null,
          response.data.toString(),
        );
        throw Exception(
          'Failed completion: ${response.statusCode} - ${response.data}',
        );
      }
    } on DioException catch (e, stackTrace) {
      _log.handle(e, stackTrace, 'Network or API Error in Google AI Studio');
      throw Exception(
        'Network or API Error: ${e.message}\n${e.response?.data}',
      );
    }
  }

  Future<String> _generateOpenAICompatible(
    AiSettings settings,
    String systemPrompt,
    List<Map<String, String>> messages, {
    bool openRouterWeb = false,
  }) async {
    if (settings.apiKey.isEmpty && settings.baseUrl.contains('openai.com')) {
      _log.warning('API Key is missing for OpenAI.');
      throw Exception('API Key is missing for OpenAI.');
    }

    final headers = {
      'Content-Type': 'application/json',
      if (settings.apiKey.isNotEmpty)
        'Authorization': 'Bearer ${settings.apiKey}',
      'HTTP-Referer': 'https://pocket-isins.app',
      'X-Title': 'Pocket ISINs',
    };

    final data = {
      'model': settings.modelName,
      'messages': [
        {'role': 'system', 'content': systemPrompt},
        ...messages,
      ],
      if (openRouterWeb)
        'plugins': [
          {'id': 'web'},
        ],
    };

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
        final reply =
            response.data['choices'][0]['message']['content'] as String;
        return reply;
      } else {
        _log.handle(
          Exception('Failed completion OpenAI'),
          null,
          response.data.toString(),
        );
        throw Exception(
          'Failed completion: ${response.statusCode} - ${response.data}',
        );
      }
    } on DioException catch (e, stackTrace) {
      _log.handle(e, stackTrace, 'Network or API Error in OpenAI Compatible');
      throw Exception(
        'Network or API Error: ${e.message}\n${e.response?.data}',
      );
    }
  }
}
