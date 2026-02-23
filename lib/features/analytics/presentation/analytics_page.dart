import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../core/permissions/permission_explainer_page.dart';

class AnalyticsPage extends ConsumerWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permission = ref.watch(usagePermissionProvider);
    return permission.when(
      data: (granted) {
        if (!granted) {
          return Center(
            child: FilledButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PermissionExplainerPage(
                      title: 'Usage Access Permission',
                      whyNeeded: 'To show your device usage patterns and distraction trends.',
                      whatCollected: 'App usage durations and unlock count from your device only.',
                      onContinue: () => ref.read(analyticsRepositoryProvider).openSettings(),
                    ),
                  ),
                );
              },
              child: const Text('Enable Usage Analytics (Optional)'),
            ),
          );
        }

        final analytics = ref.watch(usageAnalyticsProvider);
        return analytics.when(
          data: (a) => ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(child: ListTile(title: const Text('Today Screen Time'), subtitle: Text('${a.screenTimeMinutes} minutes'))),
              Card(child: ListTile(title: const Text('Unlock Count'), subtitle: Text('${a.unlockCount}'))),
              Card(child: ListTile(title: const Text('Peak Usage Hour'), subtitle: Text(a.peakHour))),
              const SizedBox(height: 8),
              const Text('Top 5 Apps'),
              ...a.topApps.map((e) => ListTile(
                    title: Text(e['packageName'].toString()),
                    trailing: Text('${e['minutes']} min'),
                  )),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const Center(child: Text('Analytics unavailable, app still works without permission.')),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('Unable to read permission state.')),
    );
  }
}
