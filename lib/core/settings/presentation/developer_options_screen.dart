import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../application/developer_settings_provider.dart';
import 'purge_data_screen.dart';
import '../../../core/services/log/talker_provider.dart';

class DeveloperOptionsScreen extends ConsumerWidget {
  const DeveloperOptionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(developerSettingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Developer Options')),
      body: ListView(
        children: [
          CheckboxListTile(
            title: const Text('Show Log Console'),
            subtitle: const Text('Enable the Logs tab in the main navigation'),
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
              final talker = ref.read(talkerProvider);

              talker.critical(
                'Test Critical log\nSystem failure or critical event.',
              );
              talker.error(
                'Test Error log\nAn error occurred while processing.',
              );
              talker.warning(
                'Test Warning log\nSomething unexpected happened.',
              );
              talker.info('Test Info log\nSummary of action...');
              talker.debug(
                'Test Debug log\nDetails of the action with some data:\n{"key": "value", "status": "ok"}',
              );
              talker.verbose(
                'Test Verbose log\nFull context and very detailed trace for a specific event.',
              );

              talker.handle(
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
              talker.verbose('Test Long Log (>5000 chars)\n$longString');

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Test logs generated!')),
              );
            },
          ),
        ],
      ),
    );
  }
}
