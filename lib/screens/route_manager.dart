import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:minimalisticpush/managers/preferences_manager.dart';
import 'package:minimalisticpush/screens/error_screen.dart';
import 'package:minimalisticpush/screens/main_screen.dart';
import 'package:minimalisticpush/screens/onboarding_screen.dart';
import 'package:minimalisticpush/widgets/background.dart';

import 'package:sprinkle/Observer.dart';
import 'package:sprinkle/sprinkle.dart';

class RouteManager extends StatelessWidget {
  const RouteManager({key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var preferencesManager = context.use<PreferencesManager>();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
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
      ),
    );
  }
}
