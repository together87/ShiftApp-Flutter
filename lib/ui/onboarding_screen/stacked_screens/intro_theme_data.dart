import 'package:flutter/material.dart';

// Theme data only relevant for Onboarding Screens
abstract class IntroThemeData {
  static const TextStyle introTitleTextStyle =
      TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: Colors.white);

  static const EdgeInsets introTextPadding =
      EdgeInsets.symmetric(horizontal: 20.0);
}
