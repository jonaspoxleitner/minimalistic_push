import 'package:flutter/material.dart';
import 'package:minimalisticpush/controllers/onboarding_controller.dart';
import 'package:minimalisticpush/controllers/session_controller.dart';
import 'package:minimalisticpush/localizations.dart';

import '../screens/screens.dart';
import '../widgets/widgets.dart';
import '../styles/styles.dart';

class OnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController(initialPage: 0);

    return Container(
      alignment: Alignment.center,
      constraints: BoxConstraints.expand(),
      child: PageView.builder(
        onPageChanged: (value) {
          Background.instance.setSessions([0.2, 0.4, 0.6, 0.8, 1.0]);

          switch (value) {
            case 0:
              Background.instance.animateTo(0.0);
              break;
            case 1:
              Background.instance.animateTo(0.6);
              break;
            case 2:
              Background.instance.animateTo(1.0);
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
                    Column(
                      children: [
                        InstructionWidget(
                          number: 1,
                          text: MyLocalizations.of(context)
                              .getLocale('onboarding')['instructions'][0],
                        ),
                        InstructionWidget(
                          number: 2,
                          text: MyLocalizations.of(context)
                              .getLocale('onboarding')['instructions'][1],
                        ),
                        InstructionWidget(
                          number: 3,
                          text: MyLocalizations.of(context)
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
                    Column(
                      children: [
                        BenefitWidget(
                          iconData: Icons.bar_chart,
                          text: MyLocalizations.of(context)
                              .getLocale('onboarding')['benefits'][0],
                        ),
                        BenefitWidget(
                          iconData: Icons.cloud_off,
                          text: MyLocalizations.of(context)
                              .getLocale('onboarding')['benefits'][1],
                        ),
                        BenefitWidget(
                          iconData: Icons.code,
                          text: MyLocalizations.of(context)
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
                          SessionController.instance.setNormalizedSessions();
                          OnboardingController.instance.acceptOnboarding();
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
    );
  }
}
