import 'package:flutter/material.dart';

import '../controllers/controllers.dart';

import '../models/session.dart';

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
  SessionController sessionController = SessionController();
  PageController pageController = PageController();
  List<Widget> sessionWidgets = [];
  var sessions;

  @override
  void setState(fn) {
    sessions = sessionController.getSessions();
    sessionWidgets = [];

    for (Session session in sessions) {
      sessionWidgets.add(
        SessionWidget(session: session),
      );
    }

    super.setState(() {});
  }

  void _incrementCounter() {
    _counter++;
    super.setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SessionController sessionController = SessionController();
    var size = MediaQuery.of(context).size;

    return Container(
      height: size.height,
      width: size.width,
      child: PageView(
        onPageChanged: (int) {
          this.setState(() {});
        },
        controller: pageController,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  LocationText(
                    text: 'Training Mode',
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.settings,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          // show settings
                          pageController.animateToPage(
                            2,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOutQuart,
                          );
                        },
                      )
                    ],
                  )
                ],
              ),
              Spacer(),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: GestureDetector(
                    onTap: _incrementCounter,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Text(_counter.toString()),
                    ),
                  ),
                ),
              ),
              Spacer(),
              CustomButton(
                text: 'Add session to database',
                onTap: () {
                  sessionController.insertSession(Session(count: _counter));
                  _counter = 0;
                  this.setState(() {});
                },
              ),
              CustomButton(
                text: 'Clear counter',
                onTap: () {
                  _counter = 0;
                  this.setState(() {});
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomButton(
                    text: 'Sessions',
                    onTap: () {
                      // show sessions
                      pageController.animateToPage(
                        1,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOutQuart,
                      );
                    },
                  ),
                ],
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              LocationText(
                text: 'Your Sessions',
              ),
              Expanded(
                child: FutureBuilder(
                  future: sessionController.loadSessions(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView(
                        children: sessionWidgets,
                      );
                    } else if (snapshot.hasError) {
                      return Text('Something went wrong.');
                    } else {
                      return LoadingScreen();
                    }
                  },
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              LocationText(
                text: 'Settings/Tests',
              ),
              CustomButton(
                text: 'Return to Onboarding (debug)',
                onTap: () {
                  widget.screenState.returnToOnboarding();
                },
              ),
              CustomButton(
                text: 'Clear database (debug)',
                onTap: () {
                  sessionController.clear();
                  this.setState(() {});
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
