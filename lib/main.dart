import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/database/drift_service.dart';
import 'core/settings/application/developer_settings_provider.dart';
import 'features/portfolio/presentation/portfolio_screen.dart';
import 'features/markets/presentation/markets_screen.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'features/feed/presentation/feed_screen.dart';
import 'features/bot/presentation/bot_screen.dart';
import 'features/logs/presentation/log_screen.dart';
import 'core/services/log/custom_talker_formatter.dart';
import '../../../core/services/log/talker_provider.dart';
import 'core/theme/app_drawer.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Drift
  final driftServiceInstance = DriftService();
  await driftServiceInstance.init();

  final talker = TalkerFlutter.init(
    settings: TalkerSettings(
      useHistory: true,
      maxHistoryItems: 1000,
      useConsoleLogs: true,
    ),
    logger: TalkerLogger(
      settings: TalkerLoggerSettings(
        level: LogLevel.info,
        colors: {LogLevel.debug: AnsiPen()..green()},
      ),
      formatter: CustomTalkerFormatter(() {
        // Will be updated when shared prefs loads, but default is false
        return false;
      }),
    ),
  );

  FlutterError.onError = (details) {
    talker.handle(details.exception, details.stack, 'Uncaught Flutter Error');
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    talker.handle(error, stack, 'Uncaught Platform Error');
    return true;
  };

  runZonedGuarded(() {
    runApp(
      ProviderScope(
        observers: [RiverpodErrorObserver(talker)],
        overrides: [
          driftServiceProvider.overrideWithValue(driftServiceInstance),
          talkerProvider.overrideWithValue(talker),
        ],
        child: const PocketIsinsApp(),
      ),
    );
  }, (error, stack) {
    talker.handle(error, stack, 'Uncaught App Error');
  });
}

class RiverpodErrorObserver extends ProviderObserver {
  final Talker talker;

  RiverpodErrorObserver(this.talker);

  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    talker.handle(
      error,
      stackTrace,
      'Riverpod Provider Error: ${provider.name ?? provider.runtimeType}',
    );
  }
}

// Simple StateProvider for the active tab index
final currentTabProvider = StateProvider<int>((ref) => 0);

class PocketIsinsApp extends StatelessWidget {
  const PocketIsinsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
    final activeIndex = currentIndex >= screens.length
        ? screens.length - 1
        : currentIndex;

    // Reset currentTab if it's out of bounds after toggling
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (currentIndex >= screens.length) {
        ref.read(currentTabProvider.notifier).state = screens.length - 1;
      }
    });

    return Scaffold(
      drawer:
          activeIndex == screens.length - 1 && developerSettings.showLogConsole
          ? const AppDrawer()
          : null,
      body: screens[activeIndex],
      bottomNavigationBar: Container(
        color:
            Theme.of(context).bottomNavigationBarTheme.backgroundColor ??
            Theme.of(context).colorScheme.surface,
        child: SafeArea(
          child: Center(
            heightFactor: 1.0,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600.0),
              child: BottomNavigationBar(
                currentIndex: activeIndex,
                type: BottomNavigationBarType.fixed,
                elevation: 0,
                backgroundColor: Colors.transparent,
                onTap: (index) =>
                    ref.read(currentTabProvider.notifier).state = index,
                items: [
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.list_alt),
                    label: 'ISINs',
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
            ),
          ),
        ),
      ),
    );
  }
}
