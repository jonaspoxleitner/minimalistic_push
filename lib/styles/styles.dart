import 'package:minimalisticpush/widgets/custom_button.dart';
import 'package:theme_provider/theme_provider.dart';

import 'package:flutter/material.dart';

class AppThemes {
  static List<AppTheme> list = [
    AppTheme(
      id: "outdoor",
      data: ThemeData(
        primaryColor: Color(0xFF263D42),
        accentColor: Color(0xFF3F5E5A),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      description: 'Outdoor',
    ),
    AppTheme(
      id: "deep_ocean",
      data: ThemeData(
        primaryColor: Color(0xFF2A4158),
        accentColor: Color(0xFF597387),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      description: 'Deep Ocean',
    ),
    AppTheme(
      id: "wine",
      data: ThemeData(
        primaryColor: Color(0xFF7B506F),
        accentColor: Color(0xFF385F71),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      description: 'Wine',
    ),
    AppTheme(
      id: "vulcano",
      data: ThemeData(
        primaryColor: Color(0xFF880044),
        accentColor: Color(0xFFAA1155),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      description: 'Vulcano',
    ),
    AppTheme(
      id: "space",
      data: ThemeData(
        primaryColor: Color(0xFF2D3142),
        accentColor: Color(0xFF4F5D75),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      description: 'Space',
    ),
  ];

  static List<Widget> getThemeButtons(BuildContext context) {
    List<Widget> themeButtons = [];

    for (AppTheme theme in list) {
      themeButtons.add(
        CustomButton(
          text: theme.description,
          onTap: () {
            ThemeProvider.controllerOf(context).setTheme(theme.id);
          },
        ),
      );
    }

    return themeButtons;
  }
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
