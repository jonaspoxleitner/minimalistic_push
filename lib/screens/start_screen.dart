import 'package:flutter/material.dart';

import 'screens.dart';

import '../widgets/widgets.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({this.screenState});

  final ScreenState screenState;

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Container(
      height: size.height,
      width: size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: GestureDetector(
                onTap: _incrementCounter,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Text('${_counter}'),
                ),
              ),
            ),
          ),
          CustomButton(
            text: 'Add session to database',
            onTap: () {
              //widget.widget.controller
              //.insertSession(Session(id: 1, count: _counter));
            },
          ),
          CustomButton(
            text: 'Return to Onboarding',
            onTap: () {
              widget.screenState.returnToOnboarding();
            },
          ),
        ],
      ),
    );
  }
}
