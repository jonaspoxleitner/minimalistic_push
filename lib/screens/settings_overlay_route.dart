import 'package:flutter/material.dart';
import 'package:minimalisticpush/controllers/onboarding_controller.dart';
import 'package:minimalisticpush/controllers/session_controller.dart';
import 'package:minimalisticpush/screens/main_screen.dart';
import 'package:minimalisticpush/widgets/widgets.dart';
import 'package:theme_provider/theme_provider.dart';

class SettingsOverlayRoute extends OverlayRoute {
  MainScreenState underlyingState;
  Widget child;

  SettingsOverlayRoute({@required this.underlyingState, this.child});

  @override
  Iterable<OverlayEntry> createOverlayEntries() {
    Background.instance.setReadingMode(true);
    Background.instance.setStateIfMounted();

    return [
      new OverlayEntry(builder: (context) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            constraints: BoxConstraints.expand(),
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
                            padding: const EdgeInsets.all(16.0),
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            icon: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              this.underlyingState.setVisibility(true);

                              Background.instance.setReadingMode(false);
                              Background.instance.setStateIfMounted();

                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      )
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, bottom: 16.0),
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(32.0),
                          ),
                        ),
                        child: ListView(
                          children: [
                            CustomButton(
                              text: 'Return to Onboarding (debug)',
                              onTap: () {
                                Background.instance.setReadingMode(false);
                                Background.instance.setStateIfMounted();

                                Navigator.of(context).pop();
                                OnboardingController.instance
                                    .returnToOnboarding();
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
                                ThemeProvider.controllerOf(context)
                                    .setTheme('red_theme');
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
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
