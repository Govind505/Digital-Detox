import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../analytics/presentation/analytics_page.dart';
import '../../focus/presentation/focus_page.dart';
import '../../premium/presentation/premium_page.dart';
import '../../settings/presentation/settings_page.dart';
import '../../streak/presentation/streak_card.dart';

class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key});

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    ref.watch(hiveInitProvider);
    final pages = [
      const FocusPage(),
      const AnalyticsPage(),
      const PremiumPage(),
      const SettingsPage(),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('DIGITAL DETOX COACH')),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(12),
            child: StreakCard(),
          ),
          Expanded(child: pages[_index]),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (idx) => setState(() => _index = idx),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.timer), label: 'Focus'),
          NavigationDestination(icon: Icon(Icons.analytics), label: 'Analytics'),
          NavigationDestination(icon: Icon(Icons.workspace_premium), label: 'Premium'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
