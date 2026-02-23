class StreakState {
  const StreakState({required this.currentDays, required this.longestDays, required this.totalFocusHours});

  final int currentDays;
  final int longestDays;
  final int totalFocusHours;

  List<String> get badges {
    final list = <String>[];
    if (currentDays >= 7) list.add('7 Day Warrior');
    if (currentDays >= 30) list.add('30 Day Monk');
    if (totalFocusHours >= 100) list.add('100 Hour Deep Focus');
    return list;
  }
}
