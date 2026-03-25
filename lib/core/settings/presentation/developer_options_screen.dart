import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/developer_settings_provider.dart';

class DeveloperOptionsScreen extends ConsumerWidget {
  const DeveloperOptionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final debugLabelsEnabled = ref.watch(developerSettingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Developer Options'),
      ),
      body: ListView(
        children: [
          CheckboxListTile(
            title: const Text('Debug labels'),
            subtitle: const Text('Show technical labels like "Round" on Feed cards'),
            value: debugLabelsEnabled,
            onChanged: (value) {
              if (value != null) {
                ref.read(developerSettingsProvider.notifier).setDebugLabelsEnabled(value);
              }
            },
          ),
        ],
      ),
    );
  }
}
