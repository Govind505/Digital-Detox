# DIGITAL DETOX COACH

Android-only Flutter app for voluntary focus coaching with soft interventions.

## Build
1. Install Flutter stable.
2. Run `flutter pub get`.
3. Add Firebase Android config (`google-services.json`).
4. Run `flutter run -d android`.

## Policy Compliance
- No launcher replacement.
- No app blocking or kiosk mode.
- Permissions are optional with explanation and Not Now path.
- App works without denied permissions.

## Architecture
- Clean Architecture + Riverpod.
- Hive local session history.
- MethodChannel for Android UsageStatsManager.
- Firebase Analytics + Crashlytics.
- AdMob banner for free tier.
- In-app purchase (one-time premium unlock).
