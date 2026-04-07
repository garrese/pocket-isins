import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:pocket_isins/core/services/log/app_logger.dart';
import 'package:pocket_isins/features/feed/data/repositories/feed_repository.dart';

class MockDio extends Mock implements Dio {}
class MockAppLogger extends Mock implements AppLogger {}

void main() {
  late MockDio mockDio;
  late MockAppLogger mockAppLogger;
  late FeedRepository feedRepository;

  setUp(() {
    mockDio = MockDio();
    mockAppLogger = MockAppLogger();
    feedRepository = FeedRepository(mockDio, mockAppLogger);

    when(() => mockAppLogger.verbose(any())).thenReturn(null);
    when(() => mockAppLogger.info(any())).thenReturn(null);
    when(() => mockAppLogger.debug(any())).thenReturn(null);
    when(() => mockAppLogger.warning(any(), any(), any())).thenReturn(null);
    when(() => mockAppLogger.handle(any(), any(), any())).thenReturn(null);
  });

  group('HttpDate', () {
    test('parses correct HTTP date', () {
      final date = HttpDate.parse('Thu, 15 Feb 2024 12:34:56 GMT');
      expect(date.year, 2024);
      expect(date.month, 2);
      expect(date.day, 15);

      // Since it maps to local time, we check UTC representation just in case
      // Or we can check if it returns a valid date instead of just now
      expect(date.toUtc().hour, 12);
      expect(date.toUtc().minute, 34);
      expect(date.toUtc().second, 56);
    });

    test('falls back to now on invalid date', () {
      final now = DateTime.now();
      final date = HttpDate.parse('Invalid Date String');
      // The difference should be less than 1 second
      expect(date.difference(now).inSeconds, closeTo(0, 1));
    });
  });

  group('FeedRepository - fetchNewsForIsin', () {
    test('parses valid XML feed properly', () async {
      const xmlResponse = '''
      <?xml version="1.0" encoding="UTF-8"?>
      <rss version="2.0">
        <channel>
          <title>Test Feed</title>
          <item>
            <title>First News Title</title>
            <link>https://example.com/news1</link>
            <pubDate>Thu, 15 Feb 2024 12:34:56 GMT</pubDate>
            <source url="https://example.com">Example Source</source>
          </item>
          <item>
            <title>Second News Title</title>
            <link>https://example.com/news2</link>
            <pubDate>Fri, 16 Feb 2024 10:00:00 GMT</pubDate>
            <source url="https://example.com">Another Source</source>
          </item>
        </channel>
      </rss>
      ''';

      when(() => mockDio.get(any(), options: any(named: 'options')))
          .thenAnswer((_) async => Response(
                requestOptions: RequestOptions(path: ''),
                statusCode: 200,
                data: xmlResponse,
              ));

      final result = await feedRepository.fetchNewsForIsin(
        isinId: 1,
        isinName: 'Test ISIN',
        round: 1,
        subround: 1,
        existingLinks: {},
        existingTitles: {},
      );

      expect(result.length, 2);

      expect(result[0].title, 'First News Title');
      expect(result[0].link, 'https://example.com/news1');
      expect(result[0].sourceName, 'Example Source');

      expect(result[1].title, 'Second News Title');
      expect(result[1].link, 'https://example.com/news2');
    });

    test('filters duplicate news by link and title', () async {
      const xmlResponse = '''
      <?xml version="1.0" encoding="UTF-8"?>
      <rss version="2.0">
        <channel>
          <item>
            <title>Duplicate News Title</title>
            <link>https://example.com/duplicate_title_diff_link</link>
            <pubDate>Thu, 15 Feb 2024 12:34:56 GMT</pubDate>
          </item>
          <item>
            <title>Different Title</title>
            <link>https://example.com/duplicate_link</link>
            <pubDate>Fri, 16 Feb 2024 10:00:00 GMT</pubDate>
          </item>
          <item>
            <title>Unique News Title</title>
            <link>https://example.com/unique_link</link>
            <pubDate>Fri, 16 Feb 2024 10:00:00 GMT</pubDate>
          </item>
        </channel>
      </rss>
      ''';

      when(() => mockDio.get(any(), options: any(named: 'options')))
          .thenAnswer((_) async => Response(
                requestOptions: RequestOptions(path: ''),
                statusCode: 200,
                data: xmlResponse,
              ));

      final existingLinks = {'https://example.com/duplicate_link'};
      final existingTitles = {'duplicate news title'};

      final result = await feedRepository.fetchNewsForIsin(
        isinId: 1,
        isinName: 'Test ISIN',
        round: 1,
        subround: 1,
        existingLinks: existingLinks,
        existingTitles: existingTitles,
      );

      expect(result.length, 1);
      expect(result[0].title, 'Unique News Title');
      expect(result[0].link, 'https://example.com/unique_link');
    });

    test('handles failed API gracefully', () async {
      when(() => mockDio.get(any(), options: any(named: 'options')))
          .thenAnswer((_) async => Response(
                requestOptions: RequestOptions(path: ''),
                statusCode: 500,
                data: 'Internal Server Error',
              ));

      final result = await feedRepository.fetchNewsForIsin(
        isinId: 1,
        isinName: 'Test ISIN',
        round: 1,
        subround: 1,
        existingLinks: {},
        existingTitles: {},
      );

      expect(result.isEmpty, true);
    });
  });
}
