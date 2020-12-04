import 'package:flutter/material.dart';

import 'controllers/controllers.dart';

import 'screens/screens.dart';

void main() {
  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minimalistic Push',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder<Object>(
        future: SessionController.instance.setDatabase(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FutureBuilder<Object>(
              future:
                  SharedPreferencesController.instance.setSharedPreferences(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Screen(
                    onboardingVersion: SharedPreferencesController.instance
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
    );
  }
}
