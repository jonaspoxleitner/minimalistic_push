import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../controllers/shared_preferences_controller.dart';

import '../enums/application_state.dart';

import '../screens/screens.dart';

import '../widgets/widgets.dart';

// ignore: must_be_immutable
class Screen extends StatefulWidget {
  ApplicationState state;
  int newestOnboardingVersion = 2; // change to force new onboarding
  int onboardingVersion;
  ScreenState screenState = ScreenState();

  Screen({this.onboardingVersion}) {
    screenState = ScreenState();
  }

  @override
  ScreenState createState() => screenState;
}

class ScreenState extends State<Screen> {
  void acceptOnboarding() {
    setState(() {
      SharedPreferencesController.instance
          .setOnboardingVersion(widget.newestOnboardingVersion);
      widget.onboardingVersion = widget.newestOnboardingVersion;
      widget.state = ApplicationState.start;
      Background.instance.animateTo(0.6);
    });
  }

  // for debug purposes only
  void returnToOnboarding() {
    setState(() {
      SharedPreferencesController.instance.setOnboardingVersion(0);
      widget.onboardingVersion = 0;
      widget.state = ApplicationState.onboarding;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget overlay;
    var size = MediaQuery.of(context).size;
    Background.instance.setSize(size);

    if (widget.onboardingVersion < widget.newestOnboardingVersion) {
      widget.state = ApplicationState.onboarding;
    } else {
      widget.state = ApplicationState.start;
    }

    switch (widget.state) {
      case ApplicationState.onboarding:
        Background.instance.animateTo(0.0);
        overlay = OnboardingScreen(
          screenState: this,
        );
        break;
      case ApplicationState.start:
        Background.instance.animateTo(0.5);
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
