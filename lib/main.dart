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
    OnboardingController onboardingController = OnboardingController();

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
              future: onboardingController.setSharedPreferences(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Screen(
                    onboardingVersion:
                        onboardingController.getOnboardingVersion(),
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
