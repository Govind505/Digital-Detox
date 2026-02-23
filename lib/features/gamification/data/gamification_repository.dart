import 'package:shared_preferences/shared_preferences.dart';

import '../domain/gamification_state.dart';

class GamificationRepository {
  Future<GamificationState> load() async {
    final prefs = await SharedPreferences.getInstance();
    return GamificationState(xp: prefs.getInt('xp') ?? 0);
  }

  Future<void> save(GamificationState state) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('xp', state.xp);
  }
}
