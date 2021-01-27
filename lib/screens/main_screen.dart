import 'dart:async';

import 'package:flutter/material.dart';

import 'package:minimalisticpush/controllers/preferences_controller.dart';
import 'package:minimalisticpush/controllers/session_controller.dart';
import 'package:minimalisticpush/localizations.dart';
import 'package:minimalisticpush/models/session.dart';
import 'package:minimalisticpush/screens/named_overlay_route.dart';
import 'package:minimalisticpush/styles/styles.dart';
import 'package:minimalisticpush/widgets/background.dart';
import 'package:minimalisticpush/widgets/location_text.dart';

import 'package:all_sensors/all_sensors.dart';

class MainScreen extends StatefulWidget {
  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  var visibility = true;
  var trainingMode = false;
  var hardcore = false;

  var _proximity = false;
  StreamSubscription<dynamic> _streamSubscription;

  int _counter = -1;
  List<double> sessionList = [];

  void _buttonTap() {
    _counter == -1 ? this.setTrainingMode(true) : _counter++;

    // TODO: do not set state when _counter == -1 is true
    super.setState(() {});
  }

  // initializes the training mode
  // if hardcore is true, only the button press increases the counter
  // if hardcore is false, the program also listens for the proximity sensor
  void setTrainingMode(bool mode) {
    Background.instance.setStateIfMounted();

    super.setState(() {
      if (hardcore) {
        this.trainingMode = mode;
        mode ? _counter = 0 : _counter = -1;
      } else {
        this.trainingMode = mode;
        if (mode) {
          _counter = 0;
          _streamSubscription = proximityEvents.listen((ProximityEvent event) {
            setState(() {
              var p = event.getValue();
              if (_proximity && !p) {
                this._buttonTap();
              }
              _proximity = p;
            });
          });
        } else {
          _counter = -1;
          _streamSubscription.cancel();
        }
      }
    });
  }

  // this function sets the visibility of the whole widget
  // this function will be replaced with two functions: animateOut and animateIn
  void setVisibility(bool visibility) {
    this.setState(() {
      this.visibility = visibility;
    });
  }

  @override
  void setState(fn) {
    this.hardcore = PreferencesController.instance.getHardcore();
    super.setState(fn);
  }

  @override
  void initState() {
    this.hardcore = PreferencesController.instance.getHardcore();
    super.initState();
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
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
                  text: MyLocalizations.of(context)
                      .getLocale('training')['title'],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      padding: const EdgeInsets.all(16.0),
                      icon: Icon(
                        Icons.list,
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
                        MyLocalizations.of(context)
                            .getLocale('training')['start'],
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
            Text(
                MyLocalizations.of(context).getLocale('training')['hardcore']
                    [this.hardcore],
                style: TextStyles.body),
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
                  icon: const Icon(
                    Icons.done_all,
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
          title: Text(
            MyLocalizations.of(context).getLocale('training')['alert']['title'],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  MyLocalizations.of(context).getLocale('training')['alert']
                          ['contents'][0] +
                      count.toString() +
                      MyLocalizations.of(context).getLocale('training')['alert']
                          ['contents'][1],
                ),
                Text(MyLocalizations.of(context).getLocale('training')['alert']
                    ['contents'][2]),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style:
                  TextButton.styleFrom(primary: Theme.of(context).primaryColor),
              child: Text(
                MyLocalizations.of(context).getLocale('training')['alert']
                    ['continue'],
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
                MyLocalizations.of(context).getLocale('training')['alert']
                    ['end'],
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              onPressed: () {
                SessionController.instance
                    .insertSession(Session(count: _counter));
                this.setTrainingMode(false);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
