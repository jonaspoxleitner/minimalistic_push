import 'package:flutter/material.dart';
import 'package:minimalisticpush/controllers/session_controller.dart';
import 'package:minimalisticpush/models/session.dart';
import 'package:minimalisticpush/screens/screens.dart';
import 'package:minimalisticpush/widgets/widgets.dart';

class MainScreen extends StatefulWidget {
  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  var visibility = true;
  var trainingMode = false;

  int _counter = -1;

  void _buttonTap() {
    if (_counter == -1) {
      Background.instance.setStateIfMounted();
      this.trainingMode = true;
      _counter = 0;
    } else {
      _counter++;
    }
    super.setState(() {});
  }

  void setVisibility(bool visibility) {
    super.setState(() {
      this.visibility = visibility;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!trainingMode) {
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
                      padding: const EdgeInsets.all(16.0),
                      icon: Icon(
                        Icons.toc,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        // show sessions
                        Navigator.push(
                          context,
                          NamedOverlayRoute(
                            underlyingState: this,
                            overlayName: 'sessions',
                          ),
                        );
                      },
                    ),
                    IconButton(
                      padding: const EdgeInsets.all(16.0),
                      icon: Icon(
                        Icons.settings,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        // show settings
                        Navigator.push(
                          context,
                          NamedOverlayRoute(
                            underlyingState: this,
                            overlayName: 'settings',
                          ),
                        );
                      },
                    ),
                  ],
                )
              ],
            ),
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  _buttonTap();
                },
                child: Center(
                  child: Container(
                    constraints: BoxConstraints.tightForFinite(),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        const Radius.circular(24.0),
                      ),
                      border: Border.all(
                        color: Colors.white,
                        width: 4.0,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(
                        'Start',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 64.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return new Visibility(
        visible: visibility,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  padding: const EdgeInsets.all(16.0),
                  icon: Icon(
                    _counter == 0 ? Icons.close : Icons.done_all,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    // get out of training mode
                    if (_counter <= 0) {
                      super.setState(() {
                        this.trainingMode = false;
                        _counter = -1;
                        Background.instance.setStateIfMounted();
                      });
                    } else {
                      this._showCancelDialog(_counter);
                    }
                  },
                ),
              ],
            ),
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  _buttonTap();
                },
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      _counter.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 64.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _showCancelDialog(int count) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Already done?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('It seems like your counter is already at $count.'),
                Text(
                    'If you want to continue, press \'CONTINUE\' else press \'SAVE\'.'),
                Text('You can also end the session without saving.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style:
                  TextButton.styleFrom(primary: Theme.of(context).primaryColor),
              child: Text(
                'CONTINUE',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style:
                  TextButton.styleFrom(primary: Theme.of(context).primaryColor),
              child: Text(
                'SAVE',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              onPressed: () {
                SessionController.instance
                    .insertSession(Session(count: _counter));
                this.trainingMode = false;
                Background.instance.setStateIfMounted();
                _counter = -1;
                this.setState(() {});
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style:
                  TextButton.styleFrom(primary: Theme.of(context).primaryColor),
              child: Text(
                'NO SAVING',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              onPressed: () {
                this.trainingMode = false;
                Background.instance.setStateIfMounted();
                _counter = -1;
                this.setState(() {});
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
