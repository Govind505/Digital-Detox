class UsageAnalytics {
  const UsageAnalytics({
    required this.screenTimeMinutes,
    required this.unlockCount,
    required this.peakHour,
    required this.topApps,
  });

  final int screenTimeMinutes;
  final int unlockCount;
  final String peakHour;
  final List<Map<String, dynamic>> topApps;

  factory UsageAnalytics.empty() =>
      const UsageAnalytics(screenTimeMinutes: 0, unlockCount: 0, peakHour: 'N/A', topApps: []);
}
