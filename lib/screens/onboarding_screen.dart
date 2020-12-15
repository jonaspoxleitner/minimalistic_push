import 'package:flutter/material.dart';
import 'package:minimalisticpush/controllers/onboarding_controller.dart';
import 'package:minimalisticpush/controllers/session_controller.dart';

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
                      text: 'Page 1',
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Welcome to',
                        style: TextStyles.subHeading,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Minimalistic Push',
                        style: TextStyles.heading,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'The simplest push-up tracker.',
                        style: TextStyles.subHeading,
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CustomButton(
                        text: 'to page 2',
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
                      text: 'Page 2',
                    ),
                    Spacer(),
                    Column(
                      children: [
                        InstructionWidget(
                            number: 1,
                            text: "Record your sessions in the training mode."),
                        InstructionWidget(
                            number: 2,
                            text:
                                "Edit and delete sessions in the sessions overview."),
                        InstructionWidget(
                            number: 3, text: "Watch your improvement."),
                      ],
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CustomButton(
                        text: 'to page 3',
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
                      text: 'Page 3',
                    ),
                    Spacer(),
                    Column(
                      children: [
                        BenefitWidget(
                          iconData: Icons.bar_chart,
                          text: "Track your improvements over time.",
                        ),
                        BenefitWidget(
                          iconData: Icons.cloud_off,
                          text: "Keep your data on your device.",
                        ),
                        BenefitWidget(
                          iconData: Icons.code,
                          text: "Support open-source development.",
                        ),
                      ],
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CustomButton(
                        text: 'Start Application!',
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
