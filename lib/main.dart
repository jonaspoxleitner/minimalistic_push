import 'package:flutter/material.dart';

import 'package:minimalisticpush/localizations.dart';
import 'package:minimalisticpush/managers/preferences_manager.dart';
import 'package:minimalisticpush/managers/session_manager.dart';
import 'package:minimalisticpush/screens/route_manager.dart';
import 'package:minimalisticpush/styles/styles.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sprinkle/Supervisor.dart';
import 'package:sprinkle/sprinkle.dart';
import 'package:theme_provider/theme_provider.dart';

void main() {
  final supervisor = Supervisor();
  supervisor.register<SessionManager>(() => SessionManager());
  supervisor.register<PreferencesManager>(() => PreferencesManager());

  runApp(Sprinkle(supervisor: supervisor, child: MinimalisticPush()));
}

class MinimalisticPush extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      saveThemesOnChange: true,
      loadThemeOnInit: true,
      defaultThemeId: 'outdoor',
      themes: AppThemes.list,
      child: ThemeConsumer(
        child: Builder(
          builder: (themeContext) => MaterialApp(
            localizationsDelegates: [
              const MyLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: [
              const Locale('en', ''),
              const Locale('de', ''),
            ],
            title: 'Minimalistic Push',
            debugShowCheckedModeBanner: false,
            theme: ThemeProvider.themeOf(themeContext).data,
            home: RouteManager(),
          ),
        ),
      ),
    );
  }
}
