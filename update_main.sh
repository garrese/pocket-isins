cat << 'INNER_EOF' > lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/database/drift_service.dart';
import 'core/settings/application/developer_settings_provider.dart';
import 'features/portfolio/presentation/portfolio_screen.dart';
import 'features/markets/presentation/markets_screen.dart';
import 'features/feed/presentation/feed_screen.dart';
import 'features/bot/presentation/bot_screen.dart';
import 'features/logs/presentation/log_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Drift
  final driftServiceInstance = DriftService();
  await driftServiceInstance.init();

  runApp(
    ProviderScope(
      overrides: [
        driftServiceProvider.overrideWithValue(driftServiceInstance),
      ],
      child: const PocketIsinsApp(),
    ),
  );
}

// Simple StateProvider for the active tab index
final currentTabProvider = StateProvider<int>((ref) => 0);

class PocketIsinsApp extends StatelessWidget {
  const PocketIsinsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pocket ISINs',
      theme: AppTheme.darkTheme,
      home: const MainScreen(),
    );
  }
}

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(currentTabProvider);
    final developerSettings = ref.watch(developerSettingsProvider);

    final screens = [
      const PortfolioScreen(),
      const MarketsScreen(),
      const FeedScreen(),
      const BotScreen(),
      if (developerSettings.showLogConsole) const LogScreen(),
    ];

    // Ensure currentIndex is valid if the Log tab is hidden while selected
    final activeIndex = currentIndex >= screens.length ? screens.length - 1 : currentIndex;

    // Reset currentTab if it's out of bounds after toggling
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (currentIndex >= screens.length) {
        ref.read(currentTabProvider.notifier).state = screens.length - 1;
      }
    });

    return Scaffold(
      body: screens[activeIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: activeIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => ref.read(currentTabProvider.notifier).state = index,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Portfolio',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Market',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.feed),
            label: 'Feed',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.psychology),
            label: 'Bot',
          ),
          if (developerSettings.showLogConsole)
            const BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long),
              label: 'Logs',
            ),
        ],
      ),
    );
  }
}
INNER_EOF
