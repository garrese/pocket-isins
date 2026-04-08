import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/database/drift_service.dart';
import '../../../core/utils/toast_utils.dart';
import '../../../features/bot/data/ai_settings_repository.dart';
import '../../../core/services/log/talker_provider.dart';
import '../../widgets/constrained_width.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExportDataScreen extends ConsumerStatefulWidget {
  const ExportDataScreen({super.key});

  @override
  ConsumerState<ExportDataScreen> createState() => _ExportDataScreenState();
}

class _ExportDataScreenState extends ConsumerState<ExportDataScreen> {
  bool _exportIsins = false;
  bool _exportFeedNews = false;
  bool _exportChatMessages = false;
  bool _exportMarketData = false;
  bool _exportConfiguration = false;
  bool _exportAiSettings = false;

  Future<void> _performExport() async {
    if (!mounted) return;

    try {
      final db = ref.read(driftServiceProvider).db;
      final Map<String, dynamic> exportData = {};

      if (_exportIsins) {
        final isins = await db.select(db.isins).get();
        exportData['isins'] = isins.map((i) => i.toJson()).toList();

        final tickers = await db.select(db.tickers).get();
        exportData['tickers'] = tickers.map((t) => t.toJson()).toList();
      }

      if (_exportFeedNews) {
        final feedNews = await db.select(db.feedNews).get();
        exportData['feedNews'] = feedNews.map((f) => f.toJson()).toList();
      }

      if (_exportMarketData) {
        final marketData = await db.select(db.marketDataCaches).get();
        exportData['marketData'] = marketData.map((m) => m.toJson()).toList();
      }

      if (_exportChatMessages) {
        final chatMessages = await db.select(db.chatMessages).get();
        exportData['chatMessages'] = chatMessages.map((c) => c.toJson()).toList();
      }

      if (_exportConfiguration) {
        final prefs = await SharedPreferences.getInstance();
        final keys = prefs.getKeys();
        final configData = <String, dynamic>{};
        for (final key in keys) {
          configData[key] = prefs.get(key);
        }
        exportData['configuration'] = configData;
      }

      if (_exportAiSettings) {
        final aiRepo = ref.read(aiSettingsRepositoryProvider);
        final aiSettings = await aiRepo.getSettings();
        // Export all except API Key
        exportData['aiSettings'] = {
          'apiProvider': aiSettings.apiProvider,
          'baseUrl': aiSettings.baseUrl,
          'modelName': aiSettings.modelName,
          'webSearchCapability': aiSettings.webSearchCapability,
        };
      }

      final jsonString = jsonEncode(exportData);

      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/app_data_export.json');
      await file.writeAsString(jsonString);

      final xFile = XFile(file.path, mimeType: 'application/json', name: 'app_data_export.json');

      if (mounted) {
        ToastUtils.show(context, 'Data exported successfully');
        Navigator.of(context).pop();
        await Share.shareXFiles([xFile], text: 'My App Data Export');
      }
    } catch (e, stack) {
      ref.read(appLoggerProvider).handle(e, stack, 'Failed to export data');
      if (mounted) {
        ToastUtils.show(context, 'Failed to export data: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Export Data')),
      body: ConstrainedWidth.narrow(
        child: ListView(
          children: [
            CheckboxListTile(
              title: const Text('ISINs'),
              subtitle: const Text('Exports all ISINs and their associated Tickers.'),
              value: _exportIsins,
              onChanged: (value) {
                setState(() {
                  _exportIsins = value ?? false;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Feed News'),
              subtitle: const Text('Exports all cached news articles.'),
              value: _exportFeedNews,
              onChanged: (value) {
                setState(() {
                  _exportFeedNews = value ?? false;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Market Data Cache'),
              subtitle: const Text('Exports all cached market data and prices.'),
              value: _exportMarketData,
              onChanged: (value) {
                setState(() {
                  _exportMarketData = value ?? false;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Chat Messages'),
              subtitle: const Text('Exports all chat history with the AI bot.'),
              value: _exportChatMessages,
              onChanged: (value) {
                setState(() {
                  _exportChatMessages = value ?? false;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('Configuration'),
              subtitle: const Text('Exports application settings (excluding AI keys).'),
              value: _exportConfiguration,
              onChanged: (value) {
                setState(() {
                  _exportConfiguration = value ?? false;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('AI Settings'),
              subtitle: const Text('Exports AI provider, model, and capabilities (API keys are excluded).'),
              value: _exportAiSettings,
              onChanged: (value) {
                setState(() {
                  _exportAiSettings = value ?? false;
                });
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FilledButton.tonalIcon(
            onPressed: (_exportIsins || _exportFeedNews || _exportChatMessages || _exportMarketData || _exportConfiguration || _exportAiSettings)
                ? _performExport
                : null,
            icon: const Icon(Icons.download),
            label: const Text('Export Selected Data'),
          ),
        ),
      ),
    );
  }
}
