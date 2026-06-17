import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// A lightweight service that handles in-app sound feedback.
/// For browser notifications, we use the Flutter SnackBar approach
/// since web push notifications require HTTPS + service workers.
class NotificationService {
  NotificationService._();
  static final instance = NotificationService._();

  /// Play a short haptic/click sound for task completion, creation, etc.
  Future<void> playSound() async {
    try {
      await SystemSound.play(SystemSoundType.click);
    } catch (_) {
      // Silently fail on unsupported platforms
    }
  }

  /// Play an alert sound for important actions
  Future<void> playAlert() async {
    try {
      await SystemSound.play(SystemSoundType.alert);
    } catch (_) {
      // Silently fail on unsupported platforms
    }
  }

  /// Trigger haptic feedback (mobile only)
  Future<void> haptic() async {
    try {
      await HapticFeedback.mediumImpact();
    } catch (_) {
      // Silently fail on web/desktop
    }
  }
}
