import 'dart:async';

import 'package:flutter/material.dart';

import 'package:minimalisticpush/controllers/preferences_controller.dart';
import 'package:minimalisticpush/localizations.dart';
import 'package:minimalisticpush/managers/session_manager.dart';
import 'package:minimalisticpush/models/session.dart';
import 'package:minimalisticpush/screens/named_overlay_route.dart';
import 'package:minimalisticpush/styles/styles.dart';
import 'package:minimalisticpush/widgets/navigation_bar.dart';

import 'package:all_sensors/all_sensors.dart';
import 'package:sprinkle/sprinkle.dart';

class MainScreen extends StatefulWidget {
  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  final ValueNotifier<double> opacityNotifier = ValueNotifier(1.0);
  final ValueNotifier<bool> trainingModeNotifier = ValueNotifier(false);
  var hardcore = false;

  @override
  void initState() {
    this.hardcore = PreferencesController.instance.getHardcore();

    this.trainingModeNotifier.addListener(() => super.setState(() {}));

    _animationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    _animationController.animateTo(
      1.0,
      curve: Curves.easeInOutQuart,
    );

    // this listener gets executed, when this widget comes into focus again
    this.opacityNotifier.addListener(() {
      _animationController.animateTo(
        this.opacityNotifier.value,
        curve: Curves.easeInOutQuart,
      );

      super.setState(() {
        this.hardcore = PreferencesController.instance.getHardcore();
      });
    });

    super.initState();
  }

  @override
  void setState(fn) {
    this.hardcore = PreferencesController.instance.getHardcore();
    super.setState(fn);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!trainingModeNotifier.value) {
      return AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Opacity(
            opacity: _animationController.value,
            child: child,
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0.0, -20 + _animationController.value * 20),
                  child: child,
                );
              },
              child: NavigationBar(
                text:
                    MyLocalizations.of(context).getLocale('training')['title'],
                leftOption: NavigationOption(
                  icon: Icons.list,
                  onPressed: () => Navigator.push(
                    context,
                    NamedOverlayRoute(
                      opacityNotifier: this.opacityNotifier,
                      overlayName: 'sessions',
                    ),
                  ),
                ),
                rightOption: NavigationOption(
                  icon: Icons.settings,
                  onPressed: () => Navigator.push(
                    context,
                    NamedOverlayRoute(
                      opacityNotifier: this.opacityNotifier,
                      overlayName: 'settings',
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  this.trainingModeNotifier.value = true;
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
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0.0, 20 - _animationController.value * 20),
                  child: child,
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    MyLocalizations.of(context)
                        .getLocale('training')['hardcore'][this.hardcore],
                    style: TextStyles.body),
              ),
            ),
          ],
        ),
      );
    } else {
      return TrainingWidget(
        trainingMode: this.trainingModeNotifier,
        hardcore: this.hardcore,
      );
    }
  }
}

class TrainingWidget extends StatefulWidget {
  final ValueNotifier<bool> trainingMode;
  final bool hardcore;

  TrainingWidget({
    Key key,
    @required this.trainingMode,
    @required this.hardcore,
  }) : super(key: key);

  @override
  _TrainingWidgetState createState() => _TrainingWidgetState();
}

class _TrainingWidgetState extends State<TrainingWidget> {
  int counter = 1;

  var _proximity = false;
  StreamSubscription<dynamic> _streamSubscription;

  void _buttonTap() {
    super.setState(() {
      this.counter++;
    });
  }

  @override
  void initState() {
    if (!widget.hardcore) {
      _streamSubscription = proximityEvents.listen((ProximityEvent event) {
        var p = event.getValue();
        if (_proximity && !p) {
          this._buttonTap();
        }
        _proximity = p;
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    if (!widget.hardcore) {
      _streamSubscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var sessionManager = context.use<SessionManager>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              padding: const EdgeInsets.all(16.0),
              icon: const Icon(
                Icons.close,
                color: Colors.white,
              ),
              onPressed: () => _showCancelDialog(this.counter),
            ),
            IconButton(
              padding: const EdgeInsets.all(16.0),
              icon: const Icon(
                Icons.done_all,
                color: Colors.white,
              ),
              onPressed: () {
                sessionManager.insertSession(Session(count: counter));
                widget.trainingMode.value = false;
              },
            ),
          ],
        ),
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => this._buttonTap(),
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  counter.toString(),
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
    );
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
                widget.trainingMode.value = false;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
