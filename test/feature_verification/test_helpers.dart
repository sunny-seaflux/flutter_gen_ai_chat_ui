import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pumps the widget tree until no pending timers remain.
/// This is useful for tests that use timers like [Future.delayed]
Future<void> pumpUntilNoTimers(WidgetTester tester) async {
  int iterations = 0;
  const maxIterations = 100; // Safety limit to prevent infinite loops

  // Keep pumping with small frame advances until we have no more pending frames
  // or we hit the safety limit
  while (iterations < maxIterations) {
    await tester.pump(const Duration(milliseconds: 20));
    // After each pump, if we have no pending frames, we can stop
    if (!tester.binding.hasScheduledFrame) {
      break;
    }
    iterations++;
  }

  if (iterations >= maxIterations) {
    debugPrint('Warning: Hit maximum iterations in pumpUntilNoTimers');
  }
}
