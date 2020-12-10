import 'package:flutter/material.dart';
import 'package:minimalisticpush/controllers/controllers.dart';
import 'package:minimalisticpush/screens/main_screen.dart';
import 'package:minimalisticpush/widgets/widgets.dart';
import 'package:theme_provider/theme_provider.dart';

class SettingsOverlayRoute extends OverlayRoute {
  MainScreenState underlyingState;
  Widget child;

  SettingsOverlayRoute({@required this.underlyingState, this.child});

  @override
  Iterable<OverlayEntry> createOverlayEntries() {
    return [
      new OverlayEntry(builder: (context) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            alignment: Alignment.topCenter,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      LocationText(
                        text: 'Settings/Debug',
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            icon: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              this.underlyingState.setVisibility(true);
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      )
                    ],
                  ),
                  CustomButton(
                    text: 'Return to Onboarding (debug)',
                    onTap: () {
                      Navigator.of(context).pop();
                      OnboardingController.instance.returnToOnboarding();
                    },
                  ),
                  CustomButton(
                    text: 'Clear database (debug)',
                    onTap: () {
                      SessionController.instance.clear();
                    },
                  ),
                  CustomButton(
                    text: 'green theme',
                    onTap: () {
                      ThemeProvider.controllerOf(context)
                          .setTheme('green_theme');
                    },
                  ),
                  CustomButton(
                    text: 'blue theme',
                    onTap: () {
                      ThemeProvider.controllerOf(context)
                          .setTheme('blue_theme');
                    },
                  ),
                  CustomButton(
                    text: 'red theme',
                    onTap: () {
                      ThemeProvider.controllerOf(context).setTheme('red_theme');
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      })
    ];
  }
}
