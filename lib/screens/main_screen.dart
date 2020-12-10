import 'package:flutter/material.dart';
import 'package:minimalisticpush/controllers/controllers.dart';
import 'package:minimalisticpush/models/session.dart';
import 'package:minimalisticpush/screens/screens.dart';
import 'package:minimalisticpush/widgets/widgets.dart';

class MainScreen extends StatefulWidget {
  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  List<Widget> sessionWidgets = [];
  var sessions;
  var visibility = true;

  int _counter = 0;

  void _incrementCounter() {
    Background.instance.focus(true);
    super.setState(() {
      _counter++;
    });
  }

  void setVisibility(bool visibility) {
    super.setState(() {
      this.visibility = visibility;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Visibility(
      visible: visibility,
      child: Column(
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.toc,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      // show sessions
                      var sessions = SessionController.instance.getSessions();
                      sessionWidgets = [];

                      for (Session session in sessions) {
                        sessionWidgets.add(
                          SessionWidget(session: session),
                        );
                      }

                      super.setState(() {
                        visibility = false;
                        Navigator.push(
                          context,
                          SessionsOverlayRoute(
                            underlyingState: this,
                            sessionWidgets: sessionWidgets,
                          ),
                        );
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.settings,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      // show settings
                      super.setState(() {
                        visibility = false;
                        Navigator.push(
                          context,
                          SettingsOverlayRoute(
                            underlyingState: this,
                          ),
                        );
                      });
                    },
                  ),
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
                Background.instance.focus(false);
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
              Background.instance.focus(false);
              _counter = 0;
              this.setState(() {});
            },
          ),
        ],
      ),
    );
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
              style:
                  TextButton.styleFrom(primary: Theme.of(context).primaryColor),
              child: Text(
                'Okay.',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
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
}
