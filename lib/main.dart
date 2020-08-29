import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:minimalisticpush/controllers/onboarding_controller.dart';

import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import 'controllers/session_controller.dart';
import 'screens/loading_screen.dart';
import 'screens/screen.dart';

void main() {
  // final Future<Database> database = openDatabase(
  //   join(await getDatabasesPath(), 'sessions_database.db'),
  //   onCreate: (db, version) {
  //     return db.execute(
  //       "CREATE TABLE sessions(id INTEGER PRIMARY KEY, count INTEGER)",
  //     );
  //   },
  //   version: 1,
  // );

  // SessionController sessionController = SessionController();
  // sessionController.setDatabase(database);

  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    OnboardingController onboardingController = OnboardingController();
    FlutterStatusbarcolor.setStatusBarWhiteForeground(true);

    return MaterialApp(
      title: 'Minimalistic Push',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder<Object>(
        future: onboardingController.setSharedPreferences(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Screen(
              onboardingVersion: onboardingController.getOnboardingVersion(),
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
