import 'package:flutter/services.dart';

import '../constants/app_constants.dart';

class UsageStatsChannel {
  static const MethodChannel _channel =
      MethodChannel(AppConstants.usageStatsChannel);

  Future<bool> isUsagePermissionGranted() async {
    return (await _channel.invokeMethod<bool>('isUsagePermissionGranted')) ?? false;
  }

  Future<void> openUsageSettings() async {
    await _channel.invokeMethod('openUsageSettings');
  }

  Future<Map<String, dynamic>> getUsageAnalytics() async {
    final map = await _channel.invokeMapMethod<String, dynamic>('getUsageAnalytics');
    return map ?? <String, dynamic>{};
  }
}
