import '../../../core/platform/usage_stats_channel.dart';
import '../domain/usage_analytics.dart';

class AnalyticsRepository {
  AnalyticsRepository(this._channel);
  final UsageStatsChannel _channel;

  Future<bool> isGranted() => _channel.isUsagePermissionGranted();
  Future<void> openSettings() => _channel.openUsageSettings();

  Future<UsageAnalytics> fetchUsageAnalytics() async {
    final raw = await _channel.getUsageAnalytics();
    return UsageAnalytics(
      screenTimeMinutes: (raw['screenTimeMinutes'] as int?) ?? 0,
      unlockCount: (raw['unlockCount'] as int?) ?? 0,
      peakHour: (raw['peakHour'] as String?) ?? 'N/A',
      topApps: ((raw['topApps'] as List?) ?? const <dynamic>[])
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList(),
    );
  }
}
