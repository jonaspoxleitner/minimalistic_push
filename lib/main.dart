import 'package:flutter/material.dart';

import 'package:theme_provider/theme_provider.dart';

import 'controllers/controllers.dart';

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
                        return Screen.instance;
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
