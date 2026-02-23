import 'package:hive/hive.dart';

import '../../../core/utils/focus_score_calculator.dart';
import '../domain/focus_session.dart';

class FocusRepository {
  FocusRepository(this._box);
  final Box<dynamic> _box;

  Future<void> saveSession(FocusSession session) async {
    session.focusScore = calculateFocusScore(
      appSwitchCount: session.appSwitchCount,
      unlockCount: session.unlockCount,
      minutesOutsideApp: session.timeOutsideAppMinutes,
      notificationOpenCount: session.notificationOpenCount,
    );

    await _box.add({
      'startTime': session.startTime.toIso8601String(),
      'targetDurationMinutes': session.targetDurationMinutes,
      'distractionCount': session.distractionCount,
      'unlockCount': session.unlockCount,
      'timeOutsideAppMinutes': session.timeOutsideAppMinutes,
      'notificationOpenCount': session.notificationOpenCount,
      'appSwitchCount': session.appSwitchCount,
      'focusScore': session.focusScore,
      'completed': session.completed,
    });
  }

  List<Map<dynamic, dynamic>> getHistory({required bool premium}) {
    final all = _box.values.cast<Map<dynamic, dynamic>>().toList().reversed.toList();
    return premium ? all : all.take(7).toList();
  }
}
