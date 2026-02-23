import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';

class PremiumPage extends ConsumerWidget {
  const PremiumPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final premium = ref.watch(premiumProvider);
    return premium.when(
      data: (p) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              title: Text(p.isPremium ? 'Premium Unlocked' : 'Upgrade to Premium'),
              subtitle: const Text('One-time purchase. No external payment links.'),
            ),
          ),
          const ListTile(title: Text('Premium includes:')),
          const ListTile(title: Text('• No ads')),
          const ListTile(title: Text('• Unlimited history')),
          const ListTile(title: Text('• Advanced analytics & custom themes')),
          FilledButton(
            onPressed: () async {
              final products = await ref.read(premiumRepositoryProvider).fetchProducts();
              if (products.isNotEmpty && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Product ready: ${products.first.title}')),
                );
              }
            },
            child: const Text('Load Purchase Option'),
          ),
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('Premium unavailable right now')),
    );
  }
}
