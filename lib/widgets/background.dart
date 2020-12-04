import 'package:flutter/material.dart';

import 'package:minimalisticpush/models/session.dart';
import 'package:minimalisticpush/styles/styles.dart';

class Background extends StatefulWidget {
  var size;
  var height = 0.0;
  List<Session> sessions = [];
  List<int> peaks = [];

  static final _BackgroundState _backgroundState = _BackgroundState();

  static Background _instance;
  static get instance {
    if (_instance == null) {
      _instance = Background._internal();
    }

    return _instance;
  }

  Background._internal();

  void setSize(Size size) {
    this.size = size;
  }

  void animateTo(double factor) {
    if (factor < 0.0) {
      factor = 0.0;
    } else if (factor > 1.0) {
      factor = 1.0;
    }

    if (!_backgroundState.mounted) {
      height = size.height * factor;
    } else {
      _backgroundState.setState(() {
        height = size.height * factor;
      });
    }
  }

  void setSessions(List<Session> sessions) {
    this.sessions = sessions;
    print(sessions.length.toString());

    peaks = [];

    for (Session session in sessions) {
      peaks.add(session.count);
    }

    while (peaks.length < 5) {
      peaks.insert(0, 0);
    }

    if (peaks.length > 5) {
      peaks = peaks.sublist(peaks.length - 5, peaks.length);
    }

    //_backgroundState.setState(() {});
  }

  @override
  _BackgroundState createState() => _backgroundState;
}

class _BackgroundState extends State<Background> {
  @override
  void initState() {
    print('init state background');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.size = MediaQuery.of(context).size;

    return Container(
      height: widget.size.height,
      width: widget.size.width,
      alignment: Alignment.bottomCenter,
      color: Theme.of(context).accentColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Curves
          AnimatedContainer(
            duration: Duration(milliseconds: 400),
            curve: Curves.easeInOutQuart,
            height: widget.height,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
