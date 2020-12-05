import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:minimalisticpush/controllers/controllers.dart';
import 'package:minimalisticpush/models/session.dart';
import 'package:minimalisticpush/widgets/widgets.dart';

import 'screens.dart';

class SessionsScreen extends StatefulWidget {
  PageController pageController;

  SessionsScreen({@required this.pageController});

  @override
  _SessionsScreenState createState() => _SessionsScreenState();
}

class _SessionsScreenState extends State<SessionsScreen> {
  List<Widget> sessionWidgets;

  @override
  void initState() {
    var sessions = SessionController.instance.getSessions();
    sessionWidgets = [];

    for (Session session in sessions) {
      sessionWidgets.add(
        SessionWidget(session: session),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            LocationText(
              text: 'Your Sessions',
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.navigate_next,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    widget.pageController.animateToPage(
                      1,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOutQuart,
                    );
                  },
                )
              ],
            )
          ],
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
