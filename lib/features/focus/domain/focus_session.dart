class FocusSession {
  FocusSession({
    required this.startTime,
    required this.targetDurationMinutes,
    this.distractionCount = 0,
    this.unlockCount = 0,
    this.timeOutsideAppMinutes = 0,
    this.notificationOpenCount = 0,
    this.appSwitchCount = 0,
    this.completed = false,
    this.focusScore = 0,
  });

  final DateTime startTime;
  final int targetDurationMinutes;
  int distractionCount;
  int unlockCount;
  int timeOutsideAppMinutes;
  int notificationOpenCount;
  int appSwitchCount;
  bool completed;
  int focusScore;

  int get elapsedMinutes => DateTime.now().difference(startTime).inMinutes;
  int get remainingMinutes => (targetDurationMinutes - elapsedMinutes).clamp(0, targetDurationMinutes);
}
