import 'package:flutter/material.dart';
import '../../features/bot/presentation/byok_config_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: Text(
              'Pocket ISINs',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('AI Configuration'),
            onTap: () {
              // Close the drawer before navigating
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ByokConfigScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
