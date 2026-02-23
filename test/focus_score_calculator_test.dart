import 'package:digital_detox_coach/core/utils/focus_score_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('focus score clamps between 0 and 100', () {
    expect(
      calculateFocusScore(
        appSwitchCount: 1,
        unlockCount: 1,
        minutesOutsideApp: 1,
        notificationOpenCount: 1,
      ),
      86,
    );

    expect(
      calculateFocusScore(
        appSwitchCount: 100,
        unlockCount: 100,
        minutesOutsideApp: 100,
        notificationOpenCount: 100,
      ),
      0,
    );
  });
}
