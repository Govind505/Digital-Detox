import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const ListTile(title: Text('Theme')),
        SegmentedButton<ThemeMode>(
          segments: const [
            ButtonSegment(value: ThemeMode.dark, label: Text('Dark Minimal')),
            ButtonSegment(value: ThemeMode.light, label: Text('Soft Blue')),
            ButtonSegment(value: ThemeMode.system, label: Text('System')),
          ],
          selected: {mode},
          onSelectionChanged: (value) => ref.read(themeModeProvider.notifier).state = value.first,
        ),
        const SizedBox(height: 16),
        const Card(
          child: ListTile(
            title: Text('GDPR Consent Placeholder'),
            subtitle: Text('Display consent flow before personalized ads in production release.'),
          ),
        ),
      ],
    );
  }
}
