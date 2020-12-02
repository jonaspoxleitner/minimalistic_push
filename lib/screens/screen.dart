import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../controllers/onboarding_controller.dart';
import '../controllers/session_controller.dart';

import '../enums/application_state.dart';

import '../screens/screens.dart';

import '../widgets/widgets.dart';

// ignore: must_be_immutable
class Screen extends StatefulWidget {
  ApplicationState state;
  int newestOnboardingVersion = 2; // change to force new onboarding
  int onboardingVersion;
  ScreenState screenState = ScreenState();

  SessionController controller = SessionController();

  Screen({this.onboardingVersion}) {
    screenState = ScreenState();
  }

  @override
  ScreenState createState() => screenState;
}

class ScreenState extends State<Screen> {
  Background background = Background();

  void acceptOnboarding() {
    setState(() {
      OnboardingController onboardingController = OnboardingController();
      onboardingController.setOnboardingVersion(widget.newestOnboardingVersion);
      widget.onboardingVersion = widget.newestOnboardingVersion;
      widget.state = ApplicationState.start;
      background.animateTo(0.6);
    });
  }

  // for debug purposes only
  void returnToOnboarding() {
    setState(() {
      OnboardingController onboardingController = OnboardingController();
      onboardingController.setOnboardingVersion(0);
      widget.onboardingVersion = 0;
      widget.state = ApplicationState.onboarding;
    });
  }

  Background getBackground() {
    return background;
  }

  @override
  Widget build(BuildContext context) {
    Widget overlay;
    var size = MediaQuery.of(context).size;
    background.setSize(size);

    if (widget.onboardingVersion < widget.newestOnboardingVersion) {
      widget.state = ApplicationState.onboarding;
    } else {
      widget.state = ApplicationState.start;
    }

    switch (widget.state) {
      case ApplicationState.onboarding:
        background.animateTo(0.0);
        overlay = OnboardingScreen(
          screenState: this,
        );
        break;
      case ApplicationState.start:
        background.animateTo(0.5);
        overlay = StartScreen(
          screenState: this,
        );
        break;
      case ApplicationState.sessions:
        overlay = Container(
          height: size.height,
          width: size.width,
        );
        break;
      case ApplicationState.settings:
        overlay = Container(
          height: size.height,
          width: size.width,
          color: Colors.red,
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
                background,
                SafeArea(
                  child: overlay,
                ),
              ],
            )),
      ),
    );
  }
}
