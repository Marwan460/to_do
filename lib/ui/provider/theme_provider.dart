import 'package:flutter/material.dart';



class ThemeProvider extends ChangeNotifier {
  ThemeMode currentTheme = ThemeMode.light;

  set newTheme(ThemeMode themeMode) {
    currentTheme = themeMode;
    notifyListeners();
  }

  bool get isDarkThemeEnabled => currentTheme == ThemeMode.dark;


}
