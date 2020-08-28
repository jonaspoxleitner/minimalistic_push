import 'package:flutter/material.dart';

import '../controllers/onboarding_controller.dart';
import '../controllers/session_controller.dart';

import '../enums/application_state.dart';

import '../models/session.dart';

import '../screens/screens.dart';

import '../widgets/widgets.dart';

// ignore: must_be_immutable
class Screen extends StatefulWidget {
  ApplicationState state;
  int newestOnboardingVersion = 2; // change to force new onboarding
  int onboardingVersion;

  Background background = Background();
  SessionController controller = SessionController();

  Screen({this.onboardingVersion});

  @override
  ScreenState createState() => ScreenState();
}

class ScreenState extends State<Screen> {
  void acceptOnboarding() {
    setState(() {
      OnboardingController onboardingController = OnboardingController();
      onboardingController.setOnboardingVersion(widget.newestOnboardingVersion);
      widget.onboardingVersion = widget.newestOnboardingVersion;
      widget.state = ApplicationState.start;
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

  @override
  Widget build(BuildContext context) {
    Widget overlay;
    var size = MediaQuery.of(context).size;

    if (widget.onboardingVersion < widget.newestOnboardingVersion) {
      widget.state = ApplicationState.onboarding;
    } else {
      widget.state = ApplicationState.start;
    }

    switch (widget.state) {
      case ApplicationState.onboarding:
        overlay = OnboardingScreen(size: size, screenState: this);
        break;
      case ApplicationState.start:
        overlay = StartScreen(
          screenState: this,
        );
        break;
      case ApplicationState.sessions:
        overlay = Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
        );
        break;
      case ApplicationState.settings:
        overlay = Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.red,
        );
        break;
      default:
        overlay = Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.green,
        );
    }

    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              widget.background,
              overlay,
            ],
          )),
    );
  }
}
