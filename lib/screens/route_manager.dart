import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../managers/preferences_controller.dart';
import '../widgets/background.dart';
import 'error_screen.dart';
import 'main_screen.dart';
import 'onboarding_screen.dart';

/// This class routes on startup of the application.
class RouteManager extends StatelessWidget {
  /// The constructor.
  const RouteManager({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Background(),
          SafeArea(
            child: GetBuilder<PreferencesController>(
              builder: (preferencesController) {
                switch (preferencesController.onboarding.isTrue) {
                  case true:
                    return const OnboardingScreen();
                  case false:
                    return const MainScreen();
                  default:
                    return const ErrorScreen();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
