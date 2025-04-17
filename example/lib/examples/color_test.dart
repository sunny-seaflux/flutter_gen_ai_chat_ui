import 'package:flutter/material.dart';
import 'package:flutter_gen_ai_chat_ui/src/utils/color_extensions.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';

void main() {
  // Test the color extension
  final Color color = Colors.blue;
  final Color withAlpha = color.withOpacityCompat(0.5);
  final Color withRed = color.withValues(red: 128);
  final Color withGreen = color.withValues(green: 200);
  final Color withBlue = color.withValues(blue: 50);
  final Color withMultiple =
      color.withValues(red: 255, green: 128, blue: 64).withOpacityCompat(0.8);

  // Print values
  print('Original color: $color');
  print('With alpha 0.5: $withAlpha');
  print('With red 128: $withRed');
  print('With green 200: $withGreen');
  print('With blue 50: $withBlue');
  print('With multiple changes: $withMultiple');
}
