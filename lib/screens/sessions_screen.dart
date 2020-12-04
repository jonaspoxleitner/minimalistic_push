import 'package:flutter/widgets.dart';
import 'package:minimalisticpush/controllers/controllers.dart';
import 'package:minimalisticpush/models/session.dart';
import 'package:minimalisticpush/widgets/widgets.dart';

import 'screens.dart';

class SessionsScreen extends StatefulWidget {
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
