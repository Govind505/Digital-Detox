import 'package:shared_preferences/shared_preferences.dart';

import '../domain/streak_state.dart';

class StreakRepository {
  Future<StreakState> load() async {
    final prefs = await SharedPreferences.getInstance();
    return StreakState(
      currentDays: prefs.getInt('currentDays') ?? 0,
      longestDays: prefs.getInt('longestDays') ?? 0,
      totalFocusHours: prefs.getInt('totalFocusHours') ?? 0,
    );
  }

  Future<void> save(StreakState state) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currentDays', state.currentDays);
    await prefs.setInt('longestDays', state.longestDays);
    await prefs.setInt('totalFocusHours', state.totalFocusHours);
  }
}
