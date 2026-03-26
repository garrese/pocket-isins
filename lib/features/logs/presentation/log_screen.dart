import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/services/log/log_service.dart';
import '../../../core/settings/application/developer_settings_provider.dart';
import '../../../core/theme/app_drawer.dart';
import '../../../core/services/log/domain/log_message.dart';

class LogScreen extends ConsumerWidget {
  const LogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logs = ref.watch(logServiceProvider);
    final minLogLevel = ref.watch(developerSettingsProvider).logLevel;

    final filteredLogs = logs.where((log) => log.level >= minLogLevel).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Logs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'Clear Logs',
            onPressed: () {
              ref.read(logServiceProvider.notifier).clearLogs();
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: filteredLogs.isEmpty
          ? const Center(child: Text('No logs to display.'))
          : ListView.builder(
              reverse: true,
              itemCount: filteredLogs.length,
              itemBuilder: (context, index) {
                final log = filteredLogs[filteredLogs.length - 1 - index];
                return _LogEntryTile(log: log);
              },
            ),
    );
  }
}

class _LogEntryTile extends StatelessWidget {
  final LogMessage log;

  const _LogEntryTile({required this.log});

  Color _getColorForLevel(int level) {
    switch (level) {
      case 0:
        return Colors.grey;
      case 1:
        return Colors.blue;
      case 2:
        return Colors.green;
      case 3:
        return Colors.orange;
      case 4:
        return Colors.red;
      default:
        return Colors.white;
    }
  }

  String _getLevelString(int level) {
    switch (level) {
      case 0:
        return 'VERB';
      case 1:
        return 'DBUG';
      case 2:
        return 'INFO';
      case 3:
        return 'WARN';
      case 4:
        return 'ERR';
      default:
        return 'UNK';
    }
  }

  @override
  Widget build(BuildContext context) {
    final timeStr = DateFormat('HH:mm:ss').format(log.timestamp);
    final levelStr = _getLevelString(log.level);
    final color = _getColorForLevel(log.level);

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                timeStr,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                      fontFamily: 'monospace',
                    ),
              ),
              const SizedBox(width: 8.0),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Text(
                  levelStr,
                  style: TextStyle(
                    color: color,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4.0),
          SelectableText(
            log.message,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
          ),
          if (log.error != null) ...[
            const SizedBox(height: 4.0),
            SelectableText(
              log.error!,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                color: Colors.redAccent,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
