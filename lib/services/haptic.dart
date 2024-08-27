import 'package:flutter/services.dart';

class AppHapticServices {
  AppHapticServices._();
  void hapticLight() {
    HapticFeedback.lightImpact();
  }

  void hapticMedium() {
    HapticFeedback.mediumImpact();
  }

  void hapticHeavy() {
    HapticFeedback.heavyImpact();
  }

  void hapticVibrate() {
    HapticFeedback.vibrate();
  }

  void selectionClick() {
    HapticFeedback.selectionClick();
  }
}
