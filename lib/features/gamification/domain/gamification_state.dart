class GamificationState {
  const GamificationState({required this.xp});
  final int xp;

  String get level {
    if (xp >= 5000) return 'Zen Master';
    if (xp >= 2500) return 'Deep Worker';
    if (xp >= 1000) return 'Focused';
    return 'Beginner';
  }
}
