import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:xml/xml.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/dio_provider.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../../../../core/services/log/talker_provider.dart';
import '../../domain/models/feed_news_model.dart';
import '../../../../core/services/log/app_logger.dart';

part 'feed_repository.g.dart';


class FeedRepository {
  final Dio _dio;
  final AppLogger _log;

  FeedRepository(this._dio, this._log);

  Future<List<FeedNewsModel>> fetchNewsForIsin({
    required int isinId,
    required String isinName,
    required int round,
    required int subround,
    required Set<String> existingLinks,
    required Set<String> existingTitles,
  }) async {
    try {
      final encodedQuery = Uri.encodeComponent(
        '$isinName financial news when:24h',
      );
      final url = 'https://news.google.com/rss/search?q=$encodedQuery&hl=en-US';

      _log.info('Fetching news for $isinName (Round $round)\nURL: $url');

      final response = await _dio.get(
        url,
        options: Options(
          headers: {'User-Agent': 'yaak', 'Accept': '*/*'},
          responseType: ResponseType.plain,
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final String xmlString = response.data.toString();
        _log.verbose('Feed response for $isinName:\n$xmlString');

        final document = XmlDocument.parse(xmlString);

        final items = document.findAllElements('item');

        List<FeedNewsModel> newsList = [];

        for (final item in items) {
          if (newsList.length >= 6) break;

          final title =
              item.findElements('title').firstOrNull?.innerText.trim() ?? '';
          final link =
              item.findElements('link').firstOrNull?.innerText.trim() ?? '';
          final pubDateStr =
              item.findElements('pubDate').firstOrNull?.innerText.trim() ?? '';

          final sourceElement = item.findElements('source').firstOrNull;
          final sourceName = sourceElement?.innerText.trim() ?? '';
          final sourceUrl = sourceElement?.getAttribute('url') ?? '';

          if (title.isEmpty || link.isEmpty) continue;

          final normalizedTitle = title.toLowerCase().trim();

          // Prevent duplicates against database and current batch
          if (existingTitles.contains(normalizedTitle) ||
              existingLinks.contains(link)) {
            continue;
          }

          existingTitles.add(normalizedTitle);
          existingLinks.add(link);

          DateTime pubDate;
          try {
            // e.g. "Thu, 26 Oct 2023 14:00:00 GMT" -> can use DateTime.parse on most standard RSS dates
            // But Dart's standard parsing for HTTP dates sometimes requires custom parsing
            // Let's rely on standard parsing first
            pubDate = HttpDate.parse(pubDateStr);
          } catch (e) {
            // Fallback for custom format parsing if needed, but Google RSS usually provides valid standard formats
            pubDate = DateTime.now();
          }

          newsList.add(
            FeedNewsModel(
              isinId: isinId,
              isinName: isinName,
              title: title,
              link: link,
              sourceUrl: sourceUrl,
              sourceName: sourceName,
              pubDate: pubDate,
              round: round,
              subround: subround,
            ),
          );
        }

        return newsList;
      } else {
        _log.warning(
          'Feed API Error: ${response.statusCode}',
          'Response: ${response.data}',
        );
        return [];
      }
    } catch (e, stackTrace) {
      _log.handle(e, stackTrace, 'Error fetching news for $isinName');
      return [];
    }
  }
}

class HttpDate {
  // Simple RFC 1123 parser for standard RSS dates
  static DateTime parse(String date) {
    try {
      // Dart's core package can parse HTTP dates using format
      // Or we can manually try to parse it
      return _parseRfc1123(date);
    } catch (e, stack) {
      debugPrint('Error parsing HttpDate: $date\n$e\n$stack');
      return DateTime.now();
    }
  }

  static DateTime _parseRfc1123(String dateStr) {
    // Format: "Day, dd MMM yyyy HH:mm:ss GMT"
    // To handle timezone strings properly or simply use Dart's internal parser logic
    // Luckily `DateTime.parse` is pretty good but doesn't handle the weekday part well sometimes.
    // However, if we trim it to the main part, it might.
    final parts = dateStr.split(',');
    if (parts.length == 2) {
      // We can use intl package or standard format
      // For safety, let's use a very generic fallback:
    }

    // As a robust alternative for RSS pubDate
    // The dart `HttpDate.parse` is available in `dart:io`
    return _parseViaDartIo(dateStr);
  }

  static DateTime _parseViaDartIo(String dateStr) {
    // We cannot import dart:io safely for flutter web (though we are only local),
    // but we can parse the standard parts manually or use an existing library.
    // Google News sends "Thu, 15 Feb 2024 12:34:56 GMT".
    // Let's implement a robust manual parser for this specific format.
    final regex = RegExp(
      r'\w+,\s+(\d+)\s+(\w+)\s+(\d+)\s+(\d+):(\d+):(\d+)\s+([A-Z]+|\+\d+)',
    );
    final match = regex.firstMatch(dateStr);

    if (match != null) {
      final day = int.parse(match.group(1)!);
      final monthStr = match.group(2)!;
      final year = int.parse(match.group(3)!);
      final hour = int.parse(match.group(4)!);
      final minute = int.parse(match.group(5)!);
      final second = int.parse(match.group(6)!);

      final month = _monthMap[monthStr] ?? 1;

      final dt = DateTime.utc(year, month, day, hour, minute, second);
      return dt.toLocal();
    }

    return DateTime.now();
  }

  static const _monthMap = {
    'Jan': 1,
    'Feb': 2,
    'Mar': 3,
    'Apr': 4,
    'May': 5,
    'Jun': 6,
    'Jul': 7,
    'Aug': 8,
    'Sep': 9,
    'Oct': 10,
    'Nov': 11,
    'Dec': 12,
  };
}

@riverpod
FeedRepository feedRepository(FeedRepositoryRef ref) {
  final dio = ref.watch(dioProvider);
  final log = ref.watch(appLoggerProvider);
  return FeedRepository(dio, log);
}
