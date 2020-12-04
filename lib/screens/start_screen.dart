import 'package:flutter/material.dart';

import 'package:minimalisticpush/styles/styles.dart';

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
  PageController _pageController = PageController();
  List<Widget> sessionWidgets = [];
  var sessions;

  @override
  void setState(fn) {
    sessions = SessionController.instance.getSessions();
    sessionWidgets = [];

    for (Session session in sessions) {
      sessionWidgets.add(
        SessionWidget(session: session),
      );
    }

    super.setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Container(
      height: size.height,
      width: size.width,
      child: PageView(
        onPageChanged: (int) {
          this.setState(() {});
        },
        controller: _pageController,
        children: [
          TrainingScreen(pageController: _pageController),
          SessionsScreen(sessionWidgets: sessionWidgets),
          SettingsScreen(widget: widget),
        ],
      ),
    );
  }
}

class TrainingScreen extends StatefulWidget {
  TrainingScreen({
    Key key,
    @required PageController pageController,
  })  : _pageController = pageController,
        super(key: key);

  final PageController _pageController;

  @override
  _TrainingScreenState createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  int _counter = 0;

  void _incrementCounter() {
    _counter++;
    super.setState(() {});
  }

  Future<void> _showDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Already done?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('It seems like your counter is still at 0.'),
                Text('Please finish you session.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(primary: CustomColors.dark),
              child: Text(
                'Okay.',
                style: TextStyle(
                  color: CustomColors.dark,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                    widget._pageController.animateToPage(
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
            if (_counter >= 1) {
              SessionController.instance
                  .insertSession(Session(count: _counter));
              _counter = 0;
              this.setState(() {});
            } else {
              this._showDialog();
            }
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
                widget._pageController.animateToPage(
                  1,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOutQuart,
                );
              },
            ),
          ],
        )
      ],
    );
  }
}

class SessionsScreen extends StatelessWidget {
  const SessionsScreen({
    Key key,
    @required this.sessionWidgets,
  }) : super(key: key);

  final List<Widget> sessionWidgets;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        LocationText(
          text: 'Your Sessions',
        ),
        Expanded(
          child: FutureBuilder(
            future: SessionController.instance.loadSessions(),
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
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final StartScreen widget;

  @override
  Widget build(BuildContext context) {
    return Column(
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
            SessionController.instance.clear();
            //this.setState(() {});
          },
        ),
      ],
    );
  }
}
