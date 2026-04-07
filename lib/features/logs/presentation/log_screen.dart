import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../../../core/services/log/talker_provider.dart';
import '../../../core/settings/presentation/developer_options_screen.dart';
import '../../../core/widgets/constrained_width.dart';

class LogScreen extends ConsumerWidget {
  const LogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final talker = ref.watch(talkerProvider);

    // Wrapping the entire TalkerScreen in a Container or Scaffold is tricky because TalkerScreen
    // provides its own Scaffold with AppBar. We can't wrap its internal lists directly.
    // However, if we wrap the whole thing, the AppBar inside it will also be constrained,
    // which the user said they wanted AppBars to be "common max width for the app".
    // Alternatively, we leave TalkerScreen as is.
    return ConstrainedWidth.medium(
      child: TalkerScreen(
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
          logColors: {
            TalkerKey.debug: Colors.green,
          },
        ),
      ),
    );
  }
}
