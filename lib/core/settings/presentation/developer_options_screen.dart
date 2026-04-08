import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../application/developer_settings_provider.dart';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/database/drift_service.dart';
import '../../../core/database/drift/app_database.dart';
import '../../../features/bot/data/ai_settings_repository.dart';
import '../../../features/portfolio/data/portfolio_provider.dart';
import '../../../features/markets/data/markets_provider.dart';
import '../../../features/bot/presentation/bot_provider.dart';

import 'purge_data_screen.dart';
import 'export_data_screen.dart';
import '../../../core/services/log/talker_provider.dart';
import '../../widgets/constrained_width.dart';
import 'package:pocket_isins/core/utils/toast_utils.dart';

class DeveloperOptionsScreen extends ConsumerWidget {
  const DeveloperOptionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(developerSettingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Developer Options')),
      body: ConstrainedWidth.narrow(
        child: ListView(
          children: [
            CheckboxListTile(
              title: const Text('Show Log Console'),
              subtitle: const Text(
                'Enable the Logs tab in the main navigation',
              ),
              value: settings.showLogConsole,
              onChanged: (value) {
                if (value != null) {
                  ref
                      .read(developerSettingsProvider.notifier)
                      .setShowLogConsole(value);
                }
              },
            ),
            CheckboxListTile(
              title: const Text('Enable long log details'),
              subtitle: const Text('Show full log details without truncating'),
              value: settings.enableLongLogDetails,
              onChanged: (value) {
                if (value != null) {
                  ref
                      .read(developerSettingsProvider.notifier)
                      .setEnableLongLogDetails(value);
                }
              },
            ),
            ListTile(
              title: const Text('Log Level'),
              subtitle: const Text('Set the minimum log level to display'),
              trailing: DropdownButton<LogLevel>(
                value: settings.logLevel,
                onChanged: (LogLevel? newValue) {
                  if (newValue != null) {
                    ref
                        .read(developerSettingsProvider.notifier)
                        .setLogLevel(newValue);
                  }
                },
                items:
                    [
                      LogLevel.critical,
                      LogLevel.error,
                      LogLevel.warning,
                      LogLevel.info,
                      LogLevel.debug,
                      LogLevel.verbose,
                    ].map<DropdownMenuItem<LogLevel>>((LogLevel level) {
                      return DropdownMenuItem<LogLevel>(
                        value: level,
                        child: Text(level.name.toUpperCase()),
                      );
                    }).toList(),
              ),
            ),
            ListTile(
              title: const Text('Max Log History'),
              subtitle: const Text('Limit the number of log messages saved in memory'),
              trailing: SizedBox(
                width: 80,
                child: TextFormField(
                  initialValue: settings.maxHistoryItems.toString(),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.right,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  onFieldSubmitted: (value) {
                    final parsedValue = int.tryParse(value);
                    if (parsedValue != null && parsedValue > 0) {
                      ref
                          .read(developerSettingsProvider.notifier)
                          .setMaxHistoryItems(parsedValue);
                    } else {
                      ToastUtils.show(context, 'Please enter a valid number greater than 0');
                    }
                  },
                ),
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text('Export Data'),
              subtitle: const Text('Export application data to a JSON file'),
              leading: const Icon(Icons.download),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ExportDataScreen(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Import Data'),
              subtitle: const Text('Import application data from a JSON file'),
              leading: const Icon(Icons.upload),
              onTap: () async {
                final result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['json'],
                );

                if (result != null && result.files.single.path != null) {
                  final file = File(result.files.single.path!);
                  final jsonString = await file.readAsString();

                  if (!context.mounted) return;

                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Confirm Import'),
                      content: const Text(
                        'Importing data will replace existing entries with matching IDs. Are you sure you want to proceed?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Cancel'),
                        ),
                        FilledButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Import'),
                        ),
                      ],
                    ),
                  );

                  if (confirmed == true && context.mounted) {
                    try {
                      final importData = jsonDecode(jsonString) as Map<String, dynamic>;
                      final db = ref.read(driftServiceProvider).db;

                      await db.transaction(() async {
                        if (importData.containsKey('isins')) {
                          for (var isinData in importData['isins']) {
                            await db.into(db.isins).insertOnConflictUpdate(IsinData.fromJson(isinData as Map<String, dynamic>));
                          }
                        }

                        if (importData.containsKey('tickers')) {
                          for (var tickerData in importData['tickers']) {
                            await db.into(db.tickers).insertOnConflictUpdate(TickerData.fromJson(tickerData as Map<String, dynamic>));
                          }
                        }

                        if (importData.containsKey('feedNews')) {
                          for (var newsData in importData['feedNews']) {
                            await db.into(db.feedNews).insertOnConflictUpdate(FeedNewsData.fromJson(newsData as Map<String, dynamic>));
                          }
                        }

                        if (importData.containsKey('marketData')) {
                          for (var mdData in importData['marketData']) {
                            await db.into(db.marketDataCaches).insertOnConflictUpdate(MarketDataCacheData.fromJson(mdData as Map<String, dynamic>));
                          }
                        }

                        if (importData.containsKey('chatMessages')) {
                          for (var msgData in importData['chatMessages']) {
                            await db.into(db.chatMessages).insertOnConflictUpdate(ChatMessageData.fromJson(msgData as Map<String, dynamic>));
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
                            await prefs.setStringList(entry.key, value.map((e) => e.toString()).toList());
                          }
                        }
                      }

                      if (importData.containsKey('aiSettings')) {
                        final aiSettingsData = importData['aiSettings'] as Map<String, dynamic>;
                        final aiRepo = ref.read(aiSettingsRepositoryProvider);
                        final currentSettings = await aiRepo.getSettings();
                        await aiRepo.saveSettings(currentSettings.copyWith(
                          apiProvider: aiSettingsData['apiProvider'] as String?,
                          baseUrl: aiSettingsData['baseUrl'] as String?,
                          modelName: aiSettingsData['modelName'] as String?,
                          webSearchCapability: aiSettingsData['webSearchCapability'] as bool?,
                        ));
                      }

                      ref.invalidate(portfolioProvider);
                      ref.invalidate(marketsProvider);
                      ref.invalidate(botControllerProvider);
                      ref.invalidate(developerSettingsProvider);

                      if (context.mounted) {
                        ToastUtils.show(context, 'Data imported successfully!');
                      }
                    } catch (e, stack) {
                      ref.read(appLoggerProvider).handle(e, stack, 'Failed to import data');
                      if (context.mounted) {
                        ToastUtils.show(context, 'Failed to import data: $e');
                      }
                    }
                  }
                }
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Purge Data'),
              subtitle: const Text('Selectively delete application data'),
              leading: const Icon(Icons.delete_forever),
              iconColor: Theme.of(context).colorScheme.error,
              textColor: Theme.of(context).colorScheme.error,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PurgeDataScreen(),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Test Logs'),
              subtitle: const Text(
                'Generate dummy logs to test logging functionality',
              ),
              leading: const Icon(Icons.bug_report),
              onTap: () {
                final logger = ref.read(appLoggerProvider);

                logger.critical(
                  'Test Critical log\nSystem failure or critical event.',
                );
                logger.error(
                  'Test Error log\nAn error occurred while processing.',
                );
                logger.warning(
                  'Test Warning log\nSomething unexpected happened.',
                );
                logger.info('Test Info log\nSummary of action...');
                logger.debug(
                  'Test Debug log\nDetails of the action with some data:\n{"key": "value", "status": "ok"}',
                );
                logger.verbose(
                  'Test Verbose log\nFull context and very detailed trace for a specific event.',
                );

                logger.handle(
                  Exception('Test Exception'),
                  StackTrace.current,
                  'Test Exception occurred',
                );

                // Generate long log
                final random = Random();
                const chars =
                    'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 ';
                final longString = String.fromCharCodes(
                  Iterable.generate(
                    5200,
                    (_) => chars.codeUnitAt(random.nextInt(chars.length)),
                  ),
                );
                logger.verbose('Test Long Log (>5000 chars)\n$longString');

                ToastUtils.show(context, 'Test logs generated!');
              },
            ),
          ],
        ),
      ),
    );
  }
}
