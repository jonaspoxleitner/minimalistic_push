import 'package:flutter/material.dart';

import 'package:minimalisticpush/localizations.dart';
import 'package:minimalisticpush/managers/preferences_manager.dart';
import 'package:minimalisticpush/managers/session_manager.dart';
import 'package:minimalisticpush/screens/error_screen.dart';
import 'package:minimalisticpush/styles/styles.dart';
import 'package:minimalisticpush/widgets/background.dart';
import 'package:minimalisticpush/widgets/custom_button.dart';
import 'package:minimalisticpush/widgets/location_text.dart';

import 'package:sprinkle/sprinkle.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController(initialPage: 0);
    var sessionManager = context.use<SessionManager>();
    var preferencesManager = context.use<PreferencesManager>();

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        var height = MediaQuery.of(context).size.height;
        var offset = _animationController.value * height;
        return Transform.translate(
          offset: Offset(0.0, offset),
          child: child,
        );
      },
      child: Container(
        alignment: Alignment.center,
        constraints: BoxConstraints.expand(),
        child: PageView.builder(
          onPageChanged: (value) {
            sessionManager.publishOnboardingSessions();

            switch (value) {
              case 0:
                Background.instance.factorNotifier.value = 0.0;
                break;
              case 1:
                Background.instance.factorNotifier.value = 0.6;
                break;
              case 2:
                Background.instance.factorNotifier.value = 1.0;
                break;
            }
          },
          controller: pageController,
          itemCount: 3,
          itemBuilder: (context, index) {
            switch (index) {
              case 0:
                return SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      LocationText(
                        text: MyLocalizations.of(context)
                            .getLocale('onboarding')['locations'][index],
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          MyLocalizations.of(context)
                              .getLocale('onboarding')['welcome'][0],
                          style: TextStyles.subHeading,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          MyLocalizations.of(context).getLocale('title'),
                          style: TextStyles.heading,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          MyLocalizations.of(context)
                              .getLocale('onboarding')['welcome'][1],
                          style: TextStyles.subHeading,
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CustomButton(
                          text: MyLocalizations.of(context)
                              .getLocale('onboarding')['titles'][index],
                          onTap: () {
                            pageController.animateToPage(
                              1,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOutQuart,
                            );
                          },
                        ),
                      )
                    ],
                  ),
                );
                break;
              case 1:
                return SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      LocationText(
                        text: MyLocalizations.of(context)
                            .getLocale('onboarding')['locations'][index],
                      ),
                      Spacer(),
                      _IconDescriptionList(
                        elements: [
                          _ListElement(
                            number: 1,
                            description: MyLocalizations.of(context)
                                .getLocale('onboarding')['instructions'][0],
                          ),
                          _ListElement(
                            number: 2,
                            description: MyLocalizations.of(context)
                                .getLocale('onboarding')['instructions'][1],
                          ),
                          _ListElement(
                            number: 3,
                            description: MyLocalizations.of(context)
                                .getLocale('onboarding')['instructions'][2],
                          ),
                        ],
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CustomButton(
                          text: MyLocalizations.of(context)
                              .getLocale('onboarding')['titles'][index],
                          onTap: () {
                            pageController.animateToPage(
                              2,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOutQuart,
                            );
                          },
                        ),
                      )
                    ],
                  ),
                );
                break;
              case 2:
                return SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      LocationText(
                        text: MyLocalizations.of(context)
                            .getLocale('onboarding')['locations'][index],
                      ),
                      Spacer(),
                      _IconDescriptionList(
                        elements: [
                          _ListElement(
                            iconData: Icons.bar_chart,
                            description: MyLocalizations.of(context)
                                .getLocale('onboarding')['benefits'][0],
                          ),
                          _ListElement(
                            iconData: Icons.cloud_off,
                            description: MyLocalizations.of(context)
                                .getLocale('onboarding')['benefits'][1],
                          ),
                          _ListElement(
                            iconData: Icons.code,
                            description: MyLocalizations.of(context)
                                .getLocale('onboarding')['benefits'][2],
                          ),
                        ],
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CustomButton(
                          text: MyLocalizations.of(context)
                              .getLocale('onboarding')['titles'][index],
                          onTap: () {
                            _animationController.animateTo(
                              1.0,
                              curve: Curves.easeInOutQuart,
                            );

                            sessionManager.setNormalizedSessions();
                            preferencesManager.acceptOnboarding();
                          },
                        ),
                      )
                    ],
                  ),
                );
                break;
              default:
                return ErrorScreen();
                break;
            }
          },
        ),
      ),
    );
  }
}

class _IconDescriptionList extends StatelessWidget {
  const _IconDescriptionList({key, this.elements}) : super(key: key);

  final List<_ListElement> elements;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];

    for (_ListElement e in this.elements) {
      if (e.iconData == null && e.number == null) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Expanded(
              child: Text(
                e.description,
                softWrap: true,
                style: TextStyles.body,
              ),
            ),
          ),
        );
      } else if (e.iconData == null) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    height: 36.0,
                    width: 36.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Text(e.number.toString(),
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 22.0,
                        )),
                  ),
                ),
                Flexible(
                  child: Text(
                    e.description,
                    softWrap: true,
                    style: TextStyles.body,
                  ),
                ),
              ],
            ),
          ),
        );
      } else if (e.number == null) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(
                    e.iconData,
                    color: Colors.white,
                    size: 36.0,
                  ),
                ),
                Flexible(
                  child: Text(
                    e.description,
                    softWrap: true,
                    style: TextStyles.body,
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }

    return Column(children: widgets);
  }
}

class _ListElement {
  _ListElement({
    this.iconData,
    this.number,
    @required this.description,
  }) {
    assert((this.iconData == null && this.number != null) ||
        (this.iconData != null && this.number == null));
    assert(this.description != null && this.description.trim().length != 0);
  }

  final IconData iconData;
  final int number;
  final String description;
}
