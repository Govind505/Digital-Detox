import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../features/analytics/data/analytics_repository.dart';
import '../../features/analytics/domain/usage_analytics.dart';
import '../../features/focus/data/focus_repository.dart';
import '../../features/focus/domain/focus_session.dart';
import '../../features/gamification/data/gamification_repository.dart';
import '../../features/gamification/domain/gamification_state.dart';
import '../../features/premium/data/premium_repository.dart';
import '../../features/premium/domain/premium_state.dart';
import '../../features/streak/data/streak_repository.dart';
import '../../features/streak/domain/streak_state.dart';
import '../platform/usage_stats_channel.dart';
import '../utils/focus_score_calculator.dart';

final themeModeProvider = StateProvider<ThemeMode>((_) => ThemeMode.dark);

final hiveInitProvider = FutureProvider<void>((_) async {
  await Hive.initFlutter();
  await Hive.openBox<dynamic>('focus_sessions');
});

final focusRepositoryProvider = Provider<FocusRepository>((_) {
  final box = Hive.box<dynamic>('focus_sessions');
  return FocusRepository(box);
});

final analyticsRepositoryProvider =
    Provider<AnalyticsRepository>((_) => AnalyticsRepository(UsageStatsChannel()));
final streakRepositoryProvider = Provider<StreakRepository>((_) => StreakRepository());
final gamificationRepositoryProvider = Provider<GamificationRepository>((_) => GamificationRepository());
final premiumRepositoryProvider = Provider<PremiumRepository>((_) => PremiumRepository());

class FocusController extends StateNotifier<FocusSession?> {
  FocusController(this._focusRepository, this._gamificationRepository)
      : super(null);

  final FocusRepository _focusRepository;
  final GamificationRepository _gamificationRepository;
  Timer? _timer;

  void start(int minutes) {
    _timer?.cancel();
    state = FocusSession(startTime: DateTime.now(), targetDurationMinutes: minutes);
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      final current = state;
      if (current == null) return;
      if (current.remainingMinutes <= 0) {
        complete();
      } else {
        state = current;
      }
    });
  }

  void logDistraction() {
    state?.distractionCount += 1;
    state?.appSwitchCount += 1;
    state = state;
  }

  void addOutsideMinutes(int min) {
    state?.timeOutsideAppMinutes += min;
    state = state;
  }

  Future<void> complete() async {
    final session = state;
    if (session == null) return;
    session.completed = true;
    session.focusScore = calculateFocusScore(
      appSwitchCount: session.appSwitchCount,
      unlockCount: session.unlockCount,
      minutesOutsideApp: session.timeOutsideAppMinutes,
      notificationOpenCount: session.notificationOpenCount,
    );
    await _focusRepository.saveSession(session);

    final game = await _gamificationRepository.load();
    final xp = calculateXp(focusMinutes: session.targetDurationMinutes, focusScore: session.focusScore);
    await _gamificationRepository.save(GamificationState(xp: game.xp + xp));
    _timer?.cancel();
    state = null;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final focusControllerProvider = StateNotifierProvider<FocusController, FocusSession?>(
  (ref) => FocusController(ref.watch(focusRepositoryProvider), ref.watch(gamificationRepositoryProvider)),
);

final usagePermissionProvider = FutureProvider<bool>(
  (ref) => ref.watch(analyticsRepositoryProvider).isGranted(),
);

final usageAnalyticsProvider = FutureProvider<UsageAnalytics>((ref) async {
  final granted = await ref.watch(analyticsRepositoryProvider).isGranted();
  if (!granted) return UsageAnalytics.empty();
  return ref.watch(analyticsRepositoryProvider).fetchUsageAnalytics();
});

final streakProvider = FutureProvider<StreakState>(
  (ref) => ref.watch(streakRepositoryProvider).load(),
);

final gamificationProvider = FutureProvider<GamificationState>(
  (ref) => ref.watch(gamificationRepositoryProvider).load(),
);

final premiumProvider = FutureProvider<PremiumState>(
  (ref) => ref.watch(premiumRepositoryProvider).load(),
);
