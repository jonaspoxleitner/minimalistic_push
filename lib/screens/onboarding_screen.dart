import 'package:flutter/material.dart';

import '../screens/screens.dart';
import '../widgets/widgets.dart';
import '../styles/styles.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({
    @required this.screenState,
  });

  final ScreenState screenState;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    PageController pageController = PageController(initialPage: 0);

    return Container(
      alignment: Alignment.center,
      height: size.height,
      width: size.width,
      child: PageView.builder(
        onPageChanged: (value) {
          Background.instance.animateTo(value / 2);
        },
        controller: pageController,
        itemCount: 3,
        itemBuilder: (context, index) {
          var content;

          switch (index) {
            case 0:
              content = Column(
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
              );
              break;
            case 1:
              content = Column(
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
                          text: "Record you sessions in the training mode."),
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
              );
              break;
            case 2:
              content = Column(
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
                        screenState.acceptOnboarding();
                      },
                    ),
                  )
                ],
              );
              break;
            default:
              content = ErrorScreen();
              break;
          }

          return SafeArea(
            child: content,
          );
        },
      ),
    );
  }
}
