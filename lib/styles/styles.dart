import 'package:theme_provider/theme_provider.dart';

import 'package:flutter/material.dart';

class AppThemes {
  static List<AppTheme> list = [
    AppTheme(
      id: "green_theme",
      data: ThemeData(
        primaryColor: Color(0xFF263D42),
        accentColor: Color(0xFF3F5E5A),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      description: 'green theme',
    ),
    AppTheme(
      id: "blue_theme",
      data: ThemeData(
        primaryColor: Colors.blue,
        accentColor: Colors.lightBlue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      description: 'blue theme',
    ),
    AppTheme(
      id: "red_theme",
      data: ThemeData(
        primaryColor: Color(0xFF070707),
        accentColor: Color(0xFFD1345B),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      description: 'red theme',
    ),
  ];
}

class TextStyles {
  static TextStyle heading = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w800,
    fontSize: 30.0,
  );
  static TextStyle subHeading = TextStyle(
    color: Colors.white,
    fontSize: 20.0,
  );
  static TextStyle body = TextStyle(
    color: Colors.white,
    fontSize: 18.0,
  );
}
