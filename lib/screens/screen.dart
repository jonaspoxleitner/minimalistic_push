import 'package:flutter/material.dart';

import '../controllers/onboarding_controller.dart';
import '../controllers/session_controller.dart';

import '../enums/application_state.dart';

import '../models/session.dart';
import '../models/custom_colors.dart';

import '../screens/onboarding_screen.dart';

import '../widgets/background.dart';

// ignore: must_be_immutable
class Screen extends StatefulWidget {
  ApplicationState state;
  int newestOnboardingVersion = 1;
  int onboardingVersion;
  SessionController controller = SessionController();

  Screen({this.onboardingVersion});

  @override
  ScreenState createState() => ScreenState();
}

class ScreenState extends State<Screen> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void acceptOnboarding() {
    setState(() {
      OnboardingController onboardingController = OnboardingController();
      onboardingController.setOnboardingVersion(widget.newestOnboardingVersion);
      widget.onboardingVersion = widget.newestOnboardingVersion;
      widget.state = ApplicationState.start;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    if (widget.onboardingVersion < widget.newestOnboardingVersion) {
      widget.state = ApplicationState.onboarding;
    } else {
      widget.state = ApplicationState.start;
    }

    switch (widget.state) {
      case ApplicationState.onboarding:
        return OnboardingScreen(size: size, screenState: this);
        break;
      case ApplicationState.start:
        return Scaffold(
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Background(size: size),
                Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: GestureDetector(
                          onTap: _incrementCounter,
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.white, shape: BoxShape.circle),
                            child: Text('$_counter'),
                          ),
                        ),
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        widget.controller
                            .insertSession(Session(id: 1, count: _counter));
                      },
                      child: Text('add to db'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
        break;
      case ApplicationState.sessions:
        return Scaffold(
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.blue,
          ),
        );
        break;
      case ApplicationState.settings:
        return Scaffold(
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.red,
          ),
        );
        break;
      default:
        return Scaffold(
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.green,
          ),
        );
    }
  }
}
