import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/di/providers.dart';
import '../../premium/domain/premium_state.dart';

class FocusPage extends ConsumerWidget {
  const FocusPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(focusControllerProvider);
    final premium = ref.watch(premiumProvider).value ?? const PremiumState(isPremium: false);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1D4ED8)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (session == null)
              _StartFocus(onStart: (m) => ref.read(focusControllerProvider.notifier).start(m), premium: premium)
            else
              _ActiveSession(sessionMinutes: session.remainingMinutes),
            if (!premium.isPremium) const SizedBox(height: 16),
            if (!premium.isPremium) const _BannerAdTile(),
          ],
        ),
      ),
    ).animate().fadeIn();
  }
}

class _BannerAdTile extends StatefulWidget {
  const _BannerAdTile();

  @override
  State<_BannerAdTile> createState() => _BannerAdTileState();
}

class _BannerAdTileState extends State<_BannerAdTile> {
  late final BannerAd _banner;

  @override
  void initState() {
    super.initState();
    _banner = BannerAd(
      size: AdSize.banner,
      adUnitId: AppConstants.admobBannerTestId,
      listener: const BannerAdListener(),
      request: const AdRequest(),
    )..load();
  }

  @override
  void dispose() {
    _banner.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _banner.size.width.toDouble(),
      height: _banner.size.height.toDouble(),
      child: AdWidget(ad: _banner),
    );
  }
}

class _StartFocus extends StatelessWidget {
  const _StartFocus({required this.onStart, required this.premium});

  final ValueChanged<int> onStart;
  final PremiumState premium;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Start a voluntary focus session', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [1, 25, 60, 120]
                  .map((m) => ActionChip(label: Text('$m min'), onPressed: () => onStart(m)))
                  .toList(),
            ),
            const SizedBox(height: 12),
            Text('Soft intervention only. No app blocking. ${premium.isPremium ? 'Premium active' : 'Free plan'}'),
          ],
        ),
      ),
    );
  }
}

class _ActiveSession extends ConsumerWidget {
  const _ActiveSession({required this.sessionMinutes});
  final int sessionMinutes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('$sessionMinutes min left', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 12),
            const Text('"Progress over perfection."'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () async {
                await ref.read(focusControllerProvider.notifier).complete();
                HapticFeedback.mediumImpact();
              },
              child: const Text('Complete Session'),
            ),
            TextButton(
              onPressed: () => ref.read(focusControllerProvider.notifier).logDistraction(),
              child: const Text('I left app briefly (log distraction)'),
            ),
          ],
        ),
      ),
    );
  }
}
