import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minimalistic_push/control/preferences_controller.dart';
import 'package:minimalistic_push/screens/error_screen.dart';
import 'package:minimalistic_push/screens/main_screen.dart';
import 'package:minimalistic_push/screens/onboarding_screen.dart';
import 'package:minimalistic_push/widgets/background.dart';

/// This class routes on startup of the application.
class RouteManager extends StatelessWidget {
  /// The constructor.
  const RouteManager({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
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
