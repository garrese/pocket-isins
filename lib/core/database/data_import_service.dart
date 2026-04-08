import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'drift/app_database.dart';
import '../../features/bot/data/ai_settings_repository.dart';

class DataImportService {
  static Future<void> importFromJsonString({
    required String jsonString,
    required AppDatabase db,
    AiSettingsRepository? aiRepository,
  }) async {
    final importData = jsonDecode(jsonString) as Map<String, dynamic>;

    await db.transaction(() async {
      if (importData.containsKey('isins')) {
        for (var isinData in importData['isins']) {
          final data = isinData as Map<String, dynamic>;
          if (data['registeredNames'] != null) {
            data['registeredNames'] = (data['registeredNames'] as List)
                .map((e) => e.toString())
                .toList();
          }
          await db
              .into(db.isins)
              .insertOnConflictUpdate(IsinData.fromJson(data));
        }
      }

      if (importData.containsKey('tickers')) {
        for (var tickerData in importData['tickers']) {
          await db
              .into(db.tickers)
              .insertOnConflictUpdate(
                TickerData.fromJson(tickerData as Map<String, dynamic>),
              );
        }
      }

      if (importData.containsKey('feedNews')) {
        for (var newsData in importData['feedNews']) {
          await db
              .into(db.feedNews)
              .insertOnConflictUpdate(
                FeedNewsData.fromJson(newsData as Map<String, dynamic>),
              );
        }
      }

      if (importData.containsKey('marketData')) {
        for (var mdData in importData['marketData']) {
          final data = mdData as Map<String, dynamic>;
          if (data['intradayPrices'] != null) {
            data['intradayPrices'] = (data['intradayPrices'] as List)
                .map((e) => (e as num).toDouble())
                .toList();
          }
          if (data['intradayTimestamps'] != null) {
            data['intradayTimestamps'] = (data['intradayTimestamps'] as List)
                .map((e) => (e as num).toInt())
                .toList();
          }
          await db
              .into(db.marketDataCaches)
              .insertOnConflictUpdate(MarketDataCacheData.fromJson(data));
        }
      }

      if (importData.containsKey('chatMessages')) {
        for (var msgData in importData['chatMessages']) {
          await db
              .into(db.chatMessages)
              .insertOnConflictUpdate(
                ChatMessageData.fromJson(msgData as Map<String, dynamic>),
              );
        }
      }
    });

    if (importData.containsKey('configuration')) {
      final configData = importData['configuration'] as Map<String, dynamic>;
      final prefs = await SharedPreferences.getInstance();
      for (final entry in configData.entries) {
        final value = entry.value;
        if (value is bool) {
          await prefs.setBool(entry.key, value);
        } else if (value is int) {
          await prefs.setInt(entry.key, value);
        } else if (value is double) {
          await prefs.setDouble(entry.key, value);
        } else if (value is String) {
          await prefs.setString(entry.key, value);
        } else if (value is List) {
          await prefs.setStringList(
            entry.key,
            value.map((e) => e.toString()).toList(),
          );
        }
      }
    }

    if (importData.containsKey('aiSettings') && aiRepository != null) {
      final aiSettingsData = importData['aiSettings'] as Map<String, dynamic>;
      final currentSettings = await aiRepository.getSettings();
      await aiRepository.saveSettings(
        currentSettings.copyWith(
          apiProvider: aiSettingsData['apiProvider'] as String?,
          baseUrl: aiSettingsData['baseUrl'] as String?,
          modelName: aiSettingsData['modelName'] as String?,
          webSearchCapability: aiSettingsData['webSearchCapability'] as bool?,
        ),
      );
    }
  }
}
