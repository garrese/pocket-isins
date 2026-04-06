import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../../../core/services/log/talker_provider.dart';
import '../../../core/settings/presentation/developer_options_screen.dart';

class LogScreen extends ConsumerWidget {
  const LogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final talker = ref.watch(talkerProvider);

    return TalkerScreen(
      talker: talker,
      appBarTitle: '',
      isLogsExpanded: false,
      isLogOrderReversed: true,
      appBarLeading: IconButton(
        icon: const Icon(Icons.developer_mode),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const DeveloperOptionsScreen(),
            ),
          );
        },
      ),
      theme: TalkerScreenTheme(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        textColor: Theme.of(context).colorScheme.onSurface,
        cardColor: Theme.of(context).cardColor,
      ),
    );
  }
}
