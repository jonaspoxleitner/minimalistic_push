import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:minimalisticpush/controllers/preferences_controller.dart';
import 'package:minimalisticpush/screens/error_screen.dart';
import 'package:minimalisticpush/screens/main_screen.dart';
import 'package:minimalisticpush/screens/onboarding_screen.dart';
import 'package:minimalisticpush/widgets/background.dart';

// ignore: must_be_immutable
class RouteManager extends StatefulWidget {
  RouteManagerState routeManagerState;

  static RouteManager _instance;
  static get instance {
    if (_instance == null) {
      _instance = RouteManager._internal();
    }

    return _instance;
  }

  RouteManager._internal() {
    this.routeManagerState = RouteManagerState();
  }

  void reloadRouteManagerState() {
    this.routeManagerState.setState(() {});
  }

  @override
  RouteManagerState createState() => routeManagerState;
}

class RouteManagerState extends State<RouteManager> {
  @override
  Widget build(BuildContext context) {
    Widget overlay;
    var size = MediaQuery.of(context).size;

    switch (PreferencesController.instance.showOnboarding()) {
      case true:
        Background.instance.animateTo(0.0);
        overlay = OnboardingScreen();
        break;
      case false:
        Background.instance.animateTo(0.6);
        overlay = Container(
          height: size.height,
          width: size.width,
          child: MainScreen(),
        );
        break;
      default:
        overlay = ErrorScreen();
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        // For Android.
        // Use [light] for white status bar and [dark] for black status bar.
        statusBarIconBrightness: Brightness.light,
        // For iOS.
        // Use [dark] for white status bar and [light] for black status bar.
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: Container(
            height: size.height,
            width: size.width,
            child: Stack(
              children: [
                Background.instance,
                SafeArea(
                  child: overlay,
                ),
              ],
            )),
      ),
    );
  }
}
