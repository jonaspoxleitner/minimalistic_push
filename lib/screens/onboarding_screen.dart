import 'package:flutter/material.dart';

import '../screens/screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({
    @required this.screenState,
  });

  final ScreenState screenState;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Container(
      alignment: Alignment.center,
      height: size.height,
      width: size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Welcome  to',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Minimalistic Push',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
              ),
            ),
          ),
          FlatButton(
            onPressed: () {
              screenState.acceptOnboarding();
            },
            child: Text('start'),
          ),
        ],
      ),
    );
  }
}
