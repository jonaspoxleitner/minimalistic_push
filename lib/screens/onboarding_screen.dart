import 'package:flutter/material.dart';

import '../screens/screen.dart';

import '../widgets/background.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({
    Key key,
    @required this.size,
    @required this.screenState,
  }) : super(key: key);

  final Size size;
  final ScreenState screenState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Background(size: size),
          Container(
            height: size.height,
            width: size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
          ),
        ],
      ),
    );
  }
}
