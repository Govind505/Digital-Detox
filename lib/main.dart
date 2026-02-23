import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'core/di/providers.dart';
import 'core/theme/app_themes.dart';
import 'features/shared/widgets/home_shell.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await MobileAds.instance.initialize();

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  await runZonedGuarded(
    () async {
      runApp(const ProviderScope(child: DigitalDetoxCoachApp()));
    },
    (error, stackTrace) =>
        FirebaseCrashlytics.instance.recordError(error, stackTrace, fatal: true),
  );
}

class DigitalDetoxCoachApp extends ConsumerWidget {
  const DigitalDetoxCoachApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    FirebaseAnalytics.instance.logAppOpen();

    return MaterialApp(
      title: 'Digital Detox Coach',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: AppThemes.softBlue,
      darkTheme: AppThemes.darkMinimal,
      home: const HomeShell(),
    );
  }
}
