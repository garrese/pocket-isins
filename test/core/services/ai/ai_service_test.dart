import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:pocket_isins/core/services/ai/ai_service.dart';
import 'package:pocket_isins/features/bot/data/ai_settings_repository.dart';
import 'package:pocket_isins/features/bot/domain/ai_settings.dart';

class MockDio extends Mock implements Dio {}
class MockAiSettingsRepository extends Mock implements AiSettingsRepository {}
class MockTalker extends Mock implements Talker {}

void main() {
  late MockDio mockDio;
  late MockAiSettingsRepository mockSettingsRepo;
  late MockTalker mockTalker;
  late AiService aiService;

  setUp(() {
    mockDio = MockDio();
    mockSettingsRepo = MockAiSettingsRepository();
    mockTalker = MockTalker();
    aiService = AiService(mockDio, mockSettingsRepo, mockTalker);

    when(() => mockSettingsRepo.getSettings()).thenAnswer(
        (_) async => const AiSettings(apiKey: 'dummy_key', baseUrl: 'https://api.openai.com/v1'));

    // We need to mock Talker's methods since they are called when exceptions happen or for logging
    when(() => mockTalker.verbose(any(), any(), any())).thenReturn(null);
    when(() => mockTalker.info(any(), any(), any())).thenReturn(null);
    when(() => mockTalker.debug(any(), any(), any())).thenReturn(null);
    when(() => mockTalker.warning(any(), any(), any())).thenReturn(null);
    when(() => mockTalker.handle(any(), any(), any())).thenReturn(null);
  });

  group('AiService - rateNewsRelevanceBatch', () {
    test('parses correct JSON rating output successfully', () async {
      // Setup mock dio response for OpenAI compatible API
      final mockResponseData = {
        'choices': [
          {
            'message': {
              'content': '[{"id": 123, "rating": 8}, {"id": 124, "rating": 3}]'
            }
          }
        ]
      };

      when(() => mockDio.post(any(), options: any(named: 'options'), data: any(named: 'data')))
          .thenAnswer((_) async => Response(
                requestOptions: RequestOptions(path: ''),
                statusCode: 200,
                data: mockResponseData,
              ));

      final batch = [
        {'id': 123, 'title': 'Test news 1'},
        {'id': 124, 'title': 'Test news 2'},
      ];

      final result = await aiService.rateNewsRelevanceBatch(batch);

      expect(result.length, 2);
      expect(result[123], 8);
      expect(result[124], 3);
    });

    test('handles malformed JSON gracefully', () async {
      final mockResponseData = {
        'choices': [
          {
            'message': {
              'content': 'I am an AI and I cannot rate this because reasons.'
            }
          }
        ]
      };

      when(() => mockDio.post(any(), options: any(named: 'options'), data: any(named: 'data')))
          .thenAnswer((_) async => Response(
                requestOptions: RequestOptions(path: ''),
                statusCode: 200,
                data: mockResponseData,
              ));

      final batch = [
        {'id': 123, 'title': 'Test news 1'},
      ];

      final result = await aiService.rateNewsRelevanceBatch(batch);

      expect(result.isEmpty, true);
    });

    test('handles API error gracefully', () async {
      when(() => mockDio.post(any(), options: any(named: 'options'), data: any(named: 'data')))
          .thenThrow(DioException(
            requestOptions: RequestOptions(path: ''),
            response: Response(requestOptions: RequestOptions(path: ''), statusCode: 500)
          ));

      final batch = [
        {'id': 123, 'title': 'Test news 1'},
      ];

      final result = await aiService.rateNewsRelevanceBatch(batch);

      expect(result.isEmpty, true);
    });
  });
}
