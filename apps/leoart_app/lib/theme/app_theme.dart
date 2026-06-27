import 'package:flutter/material.dart';
import 'package:shared/core/design/app_theme.dart' as design;

class AppTheme {
  AppTheme._();

  static ThemeData get light => design.AppTheme.light;
  static ThemeData get dark => design.AppTheme.dark;
}
