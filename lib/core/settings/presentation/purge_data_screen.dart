import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/drift_service.dart';
import '../application/developer_settings_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/widgets/custom_app_bar.dart';

class PurgeDataScreen extends ConsumerStatefulWidget {
  const PurgeDataScreen({super.key});

  @override
  ConsumerState<PurgeDataScreen> createState() => _PurgeDataScreenState();
}

class _PurgeDataScreenState extends ConsumerState<PurgeDataScreen> {
  bool _purgeIsins = false;
  bool _purgeFeedNews = false;
  bool _purgeChatMessages = false;
  bool _purgeMarketData = false;
  bool _purgeConfiguration = false;

  Future<void> _performPurge() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Purge'),
        content: const Text(
          'Are you sure you want to delete the selected data? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton.tonal(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.errorContainer,
              foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
            ),
            child: const Text('Purge Data'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    if (!mounted) return;

    try {
      final db = ref.read(driftServiceProvider).db;

      await db.transaction(() async {
        if (_purgeIsins) {
          // If purging ISINs, we must delete child elements first to respect foreign keys
          await db.delete(db.marketDataCaches).go();
          await db.delete(db.feedNews).go();
          await db.delete(db.tickers).go();
          await db.delete(db.isins).go();
        } else {
          // If ISINs are not being purged, we can delete FeedNews and MarketData independently if selected
          if (_purgeFeedNews) {
            await db.delete(db.feedNews).go();
          }
          if (_purgeMarketData) {
            await db.delete(db.marketDataCaches).go();
          }
        }

        if (_purgeChatMessages) {
          await db.delete(db.chatMessages).go();
        }
      });

      if (_purgeConfiguration) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        // Invalidate provider so it reloads defaults
        ref.invalidate(developerSettingsProvider);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Selected data successfully purged.')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to purge data: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(appBar: AppBar(title: const Text('Purge Data'))),
      body: ListView(
        children: [
          CheckboxListTile(
            title: const Text('ISINs'),
            subtitle: const Text(
              'Deletes all ISINs, including their associated Tickers, Positions, Market Data, and News.',
            ),
            value: _purgeIsins,
            onChanged: (value) {
              setState(() {
                _purgeIsins = value ?? false;
                if (_purgeIsins) {
                  // Automatically check dependent items to clarify they will be deleted
                  _purgeFeedNews = true;
                  _purgeMarketData = true;
                }
              });
            },
          ),
          CheckboxListTile(
            title: const Text('Feed News'),
            subtitle: const Text('Deletes all cached news articles.'),
            value: _purgeFeedNews,
            onChanged: _purgeIsins
                ? null // Disabled if ISINs are being purged (it's forced)
                : (value) {
                    setState(() {
                      _purgeFeedNews = value ?? false;
                    });
                  },
          ),
          CheckboxListTile(
            title: const Text('Market Data Cache'),
            subtitle: const Text('Deletes all cached market data and prices.'),
            value: _purgeMarketData,
            onChanged: _purgeIsins
                ? null // Disabled if ISINs are being purged (it's forced)
                : (value) {
                    setState(() {
                      _purgeMarketData = value ?? false;
                    });
                  },
          ),
          CheckboxListTile(
            title: const Text('Chat Messages'),
            subtitle: const Text('Deletes all chat history with the AI bot.'),
            value: _purgeChatMessages,
            onChanged: (value) {
              setState(() {
                _purgeChatMessages = value ?? false;
              });
            },
          ),
          CheckboxListTile(
            title: const Text('Configuration'),
            subtitle: const Text(
              'Resets all application settings to their default values.',
            ),
            value: _purgeConfiguration,
            onChanged: (value) {
              setState(() {
                _purgeConfiguration = value ?? false;
              });
            },
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FilledButton.tonalIcon(
            onPressed:
                (_purgeIsins ||
                    _purgeFeedNews ||
                    _purgeChatMessages ||
                    _purgeMarketData ||
                    _purgeConfiguration)
                ? _performPurge
                : null,
            icon: const Icon(Icons.delete_forever),
            label: const Text('Purge Selected Data'),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.errorContainer,
              foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
            ),
          ),
        ),
      ),
    );
  }
}
