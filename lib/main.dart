import 'package:flutter/material.dart';
import 'package:minimalisticpush/controllers/onboarding_controller.dart';
import 'package:minimalisticpush/controllers/session_controller.dart';

import 'package:theme_provider/theme_provider.dart';

import 'screens/screens.dart';

import 'package:minimalisticpush/styles/styles.dart';

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
      themes: AppThemes.list,
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
                    future:
                        OnboardingController.instance.setSharedPreferences(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        // the route manager handles the push and pop of the onboarding
                        return RouteManager.instance;
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
