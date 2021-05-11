import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sprinkle/Supervisor.dart';
import 'package:sprinkle/sprinkle.dart';
import 'package:theme_provider/theme_provider.dart';

import 'localizations.dart';
import 'managers/background_manager.dart';
import 'managers/preferences_manager.dart';
import 'managers/session_manager.dart';
import 'screens/route_manager.dart';
import 'styles/styles.dart';

void main() {
  final supervisor = Supervisor()
    ..register<BackgroundManager>(() => BackgroundManager())
    ..register<PreferencesManager>(() => PreferencesManager())
    ..register<SessionManager>(() => SessionManager());
  runApp(Sprinkle(supervisor: supervisor, child: MinimalisticPush()));
}

/// The application.
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
            home: AnnotatedRegion<SystemUiOverlayStyle>(
                value: const SystemUiOverlayStyle(
                  statusBarIconBrightness: Brightness.light,
                  statusBarBrightness: Brightness.dark,
                ),
                child: RouteManager()),
          ),
        ),
      ),
    );
  }
}
