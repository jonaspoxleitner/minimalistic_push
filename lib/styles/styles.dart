import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

import '../widgets/theme_button.dart';

/// A collection of the available AppThemes in the application.
class AppThemes {
  AppThemes._();

  /// The list of the available [AppTheme]s.
  static final list = <AppTheme>[
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
        primaryColor: Color(0xFF5C3C4B),
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

  /// A function, which returns a list of [ThemeButton].
  ///
  /// The context is necessary to identify the current theme.
  static List<Widget> getThemeButtons(BuildContext context) {
    var themeButtons = <Widget>[];
    var current = ThemeProvider.controllerOf(context).currentThemeId;

    for (var theme in list) {
      themeButtons.add(
        ThemeButton(
          appTheme: theme,
          isCurrent: theme.id == current,
        ),
      );
    }

    return themeButtons;
  }
}

/// A collection of the different text styles of the application.
class TextStyles {
  /// The syle for headings.
  static const heading = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w800,
    fontSize: 30.0,
  );

  /// The syle for sub headings.
  static const subHeading = TextStyle(
    color: Colors.white,
    fontSize: 20.0,
  );

  /// The style for longer text or a body.
  static const body = TextStyle(
    color: Colors.white,
    fontSize: 18.0,
  );
}
