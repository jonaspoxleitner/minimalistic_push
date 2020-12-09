import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:minimalisticpush/controllers/controllers.dart';

import '../enums/application_state.dart';

import 'screens.dart';

import '../widgets/widgets.dart';

// ignore: must_be_immutable
class RouteManager extends StatefulWidget {
  ApplicationState state;
  RouteManagerState routeManagerState;
  PageController pageController = PageController(initialPage: 1);

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
    Background.instance.setSize(size);

    if (OnboardingController.instance.showOnboarding()) {
      widget.state = ApplicationState.onboarding;
    } else {
      widget.state = ApplicationState.start;
    }

    switch (widget.state) {
      case ApplicationState.onboarding:
        Background.instance.animateTo(0.0);
        overlay = OnboardingScreen();
        break;
      case ApplicationState.start:
        Background.instance.animateTo(0.5);
        overlay = Container(
          height: size.height,
          width: size.width,
          child: PageView(
            onPageChanged: (int) {
              this.setState(() {});
            },
            controller: widget.pageController,
            children: [
              SessionsScreen(pageController: widget.pageController),
              MainScreen(),
            ],
          ),
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
