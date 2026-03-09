import 'package:flutter/material.dart';

class AppTextStyles {
  // ✅ No hardcoded color — Flutter inherits from theme automatically
  // This means light mode gets dark text, dark mode gets light text
  static const headline = TextStyle(
    fontFamily: 'Inter',
    fontSize: 24,
    fontWeight: FontWeight.w700,
    // color removed — inherited from theme
  );

  static const title = TextStyle(
    fontFamily: 'Inter',
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static const body = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static const caption = TextStyle(
    fontFamily: 'Inter',
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: Colors.grey, // grey works fine in both modes
  );
}
