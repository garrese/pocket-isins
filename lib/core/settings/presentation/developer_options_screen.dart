import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/developer_settings_provider.dart';
import 'purge_data_screen.dart';

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
            title: const Text('Debug labels'),
            subtitle: const Text(
              'Show technical labels like "Round" on Feed cards',
            ),
            value: settings.debugLabelsEnabled,
            onChanged: (value) {
              if (value != null) {
                ref
                    .read(developerSettingsProvider.notifier)
                    .setDebugLabelsEnabled(value);
              }
            },
          ),
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
            title: const Text('Log HTTP Bodies'),
            subtitle: const Text('Include large request/response bodies in logs'),
            value: settings.logHttpBodies,
            onChanged: (value) {
              if (value != null) {
                ref
                    .read(developerSettingsProvider.notifier)
                    .setLogHttpBodies(value);
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
        ],
      ),
    );
  }
}
