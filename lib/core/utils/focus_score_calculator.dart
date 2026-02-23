int calculateFocusScore({
  required int appSwitchCount,
  required int unlockCount,
  required int minutesOutsideApp,
  required int notificationOpenCount,
}) {
  final score = 100 -
      (appSwitchCount * 5) -
      (unlockCount * 3) -
      (minutesOutsideApp * 2) -
      (notificationOpenCount * 4);
  return score.clamp(0, 100);
}

int calculateXp({required int focusMinutes, required int focusScore}) =>
    (focusMinutes * 2) + focusScore;
