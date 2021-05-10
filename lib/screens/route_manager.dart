import 'package:flutter/material.dart';
import 'package:sprinkle/Observer.dart';
import 'package:sprinkle/sprinkle.dart';

import '../managers/preferences_manager.dart';
import '../widgets/background.dart';
import 'error_screen.dart';
import 'main_screen.dart';
import 'onboarding_screen.dart';

/// This class routes on startup of the application.
class RouteManager extends StatelessWidget {
  /// The constructor.
  const RouteManager({key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var preferencesManager = context.use<PreferencesManager>();

    return Scaffold(
      body: Stack(
        children: [
          Background.instance,
          SafeArea(
            child: Observer<bool>(
              stream: preferencesManager.onboarding,
              builder: (context, value) {
                switch (value) {
                  case true:
                    Background.instance.factorNotifier.value = 0.0;
                    return OnboardingScreen();
                    break;
                  case false:
                    return MainScreen();
                    break;
                  default:
                    return ErrorScreen();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
