package com.digitaldetox.coach

import android.app.usage.UsageEvents
import android.app.usage.UsageStatsManager
import android.content.Context
import android.content.Intent
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.Calendar

class MainActivity: FlutterActivity() {
    private val channel = "digital_detox/usage_stats"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel).setMethodCallHandler { call, result ->
            when (call.method) {
                "isUsagePermissionGranted" -> result.success(isUsageAccessGranted())
                "openUsageSettings" -> {
                    startActivity(Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS))
                    result.success(true)
                }
                "getUsageAnalytics" -> {
                    if (!isUsageAccessGranted()) {
                        result.success(mapOf<String, Any>(
                            "screenTimeMinutes" to 0,
                            "unlockCount" to 0,
                            "peakHour" to "N/A",
                            "topApps" to emptyList<Map<String, Any>>()
                        ))
                    } else {
                        result.success(getUsageAnalytics())
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun isUsageAccessGranted(): Boolean {
        val appOps = getSystemService(Context.APP_OPS_SERVICE) as android.app.AppOpsManager
        val mode = appOps.checkOpNoThrow(
            "android:get_usage_stats",
            android.os.Process.myUid(),
            packageName
        )
        return mode == android.app.AppOpsManager.MODE_ALLOWED
    }

    private fun getUsageAnalytics(): Map<String, Any> {
        val usageStatsManager = getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
        val end = System.currentTimeMillis()
        val start = Calendar.getInstance().apply {
            set(Calendar.HOUR_OF_DAY, 0)
            set(Calendar.MINUTE, 0)
            set(Calendar.SECOND, 0)
            set(Calendar.MILLISECOND, 0)
        }.timeInMillis

        val stats = usageStatsManager.queryUsageStats(UsageStatsManager.INTERVAL_DAILY, start, end)
        val topApps = stats
            .sortedByDescending { it.totalTimeInForeground }
            .take(5)
            .map {
                mapOf(
                    "packageName" to it.packageName,
                    "minutes" to (it.totalTimeInForeground / 60000).toInt()
                )
            }

        val screenTimeMinutes = stats.sumOf { it.totalTimeInForeground } / 60000

        val events = usageStatsManager.queryEvents(start, end)
        val event = UsageEvents.Event()
        val hourBuckets = mutableMapOf<Int, Int>()
        var unlockCount = 0
        while (events.hasNextEvent()) {
            events.getNextEvent(event)
            if (event.eventType == UsageEvents.Event.KEYGUARD_HIDDEN) {
                unlockCount++
            }
            if (event.eventType == UsageEvents.Event.MOVE_TO_FOREGROUND) {
                val cal = Calendar.getInstance()
                cal.timeInMillis = event.timeStamp
                val hour = cal.get(Calendar.HOUR_OF_DAY)
                hourBuckets[hour] = (hourBuckets[hour] ?: 0) + 1
            }
        }

        val peakHour = hourBuckets.maxByOrNull { it.value }?.key?.let { "$it:00" } ?: "N/A"

        return mapOf(
            "screenTimeMinutes" to screenTimeMinutes.toInt(),
            "unlockCount" to unlockCount,
            "peakHour" to peakHour,
            "topApps" to topApps
        )
    }
}
