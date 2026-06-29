import 'package:flutter/material.dart';

class AppSpacing {
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
}

class AppRadius {
  static const double sm = 12;
  static const double md = 18;
  static const double lg = 24;
  static const double xl = 32;
}

class AppBorders {
  static BorderRadius input = BorderRadius.circular(AppRadius.md);
  static BorderRadius card = BorderRadius.circular(AppRadius.md);
  static BorderRadius sheet = BorderRadius.circular(AppRadius.xl);
  static BorderRadius pill = BorderRadius.circular(999);
}

class AppShadows {
  static const List<BoxShadow> soft = [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 20,
      offset: Offset(0, 10),
    ),
  ];
}
