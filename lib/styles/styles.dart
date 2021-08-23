import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:minimalistic_push/widgets/theme_button.dart';

/// A collection of the available AppThemes in the application.
class AppThemes {
  AppThemes._();

  /// The outdoor theme for the applicaton.
  static final outdoor = AppTheme(
    id: 'outdoor',
    name: 'Outdoor',
    data: ThemeData(
      primaryColor: Color(0xFF263D42),
      accentColor: Color(0xFF3F5E5A),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
  );

  /// The ocean theme for the applicaton.
  static final ocean = AppTheme(
    id: 'ocean',
    name: 'Ocean',
    data: ThemeData(
      primaryColor: Color(0xFF2A4158),
      accentColor: Color(0xFF597387),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
  );

  /// The wine theme for the applicaton.
  static final wine = AppTheme(
    id: 'wine',
    name: 'Wine',
    data: ThemeData(
      primaryColor: Color(0xFF5C3C4B),
      accentColor: Color(0xFF385F71),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
  );

  /// The vulcano theme for the applicaton.
  static final vulcano = AppTheme(
    id: 'vulcano',
    name: 'Vulcano',
    data: ThemeData(
      primaryColor: Color(0xFF880044),
      accentColor: Color(0xFFAA1155),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
  );

  /// The space theme for the applicaton.
  static final space = AppTheme(
    id: 'space',
    name: 'Space',
    data: ThemeData(
      primaryColor: Color(0xFF2D3142),
      accentColor: Color(0xFF4F5D75),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
  );

  /// The list of the available themes.
  static List<AppTheme> get list => [
        outdoor,
        ocean,
        wine,
        vulcano,
        space,
      ];

  /// Returns the theme by it's id and returns the 'outdoor' theme if the id
  /// could not be found.
  static AppTheme getById(String id) {
    for (var theme in list) {
      if (theme.id == id) {
        return theme;
      }
    }

    return outdoor;
  }

  /// A function, which returns a list of [ThemeButton].
  ///
  /// The context is necessary to identify the current theme.
  static List<Widget> getThemeButtons(BuildContext context) {
    var themeButtons = <Widget>[];

    for (var theme in list) {
      themeButtons.add(ThemeButton(theme: theme, isCurrent: GetStorage().read('theme') == theme.id));
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

/// A theme object with id and name.
class AppTheme {
  /// The id of the theme.
  final String id;

  /// The name of the theme.
  final String name;

  /// The theme data.
  final ThemeData data;

  /// The constructor.
  const AppTheme({
    required this.id,
    required this.name,
    required this.data,
  });
}
