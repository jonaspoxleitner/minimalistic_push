import 'package:flutter/material.dart';
import 'package:minimalisticpush/styles/styles.dart';
import 'package:theme_provider/theme_provider.dart';

import 'controllers/controllers.dart';

import 'screens/screens.dart';

void main() {
  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      saveThemesOnChange: true,
      loadThemeOnInit: true,
      defaultThemeId: 'green_theme',
      themes: [
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
      ],
      child: ThemeConsumer(
        child: Builder(
          builder: (themeContext) => MaterialApp(
            title: 'Minimalistic Push',
            debugShowCheckedModeBanner: false,
            theme: ThemeProvider.themeOf(themeContext).data,
            home: FutureBuilder<Object>(
              future: SessionController.instance.setDatabase(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return FutureBuilder<Object>(
                    future: SharedPreferencesController.instance
                        .setSharedPreferences(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Screen(
                          onboardingVersion: SharedPreferencesController
                              .instance
                              .getOnboardingVersion(),
                        );
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      } else {
                        return LoadingScreen();
                      }
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                } else {
                  return LoadingScreen();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
