import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/database/drift_service.dart';
import 'features/portfolio/presentation/portfolio_screen.dart';
import 'features/markets/presentation/markets_screen.dart';
import 'features/feed/presentation/feed_screen.dart';
import 'features/bot/presentation/bot_screen.dart';

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

    // Placeholder screens for the skeleton
    final screens = [
      const PortfolioScreen(),
      const MarketsScreen(),
      const FeedScreen(),
      const BotScreen(),
    ];

    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed, // Ensure all items show well
        onTap: (index) => ref.read(currentTabProvider.notifier).state = index,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Portfolio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Market',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feed),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.psychology),
            label: 'Bot',
          ),
        ],
      ),
    );
  }
}

