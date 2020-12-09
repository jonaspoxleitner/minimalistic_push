import 'package:flutter/material.dart';

import 'package:minimalisticpush/models/session.dart';

class Background extends StatefulWidget {
  var chartVisibility = false;
  var size;
  var height = 0.0;
  List<Session> sessions = [];
  List<double> normalizedPeaks = [];

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
      height = size.height * factor * 0.8;
    } else {
      _backgroundState.setState(() {
        height = size.height * factor * 0.8;
      });
    }
  }

  void setSessions(List<Session> sessions) {
    var length = 5;
    this.sessions = sessions;

    List<int> peaks = [];

    for (Session session in sessions) {
      peaks.add(session.count);
    }

    while (peaks.length < length) {
      peaks.insert(0, 0);
    }

    if (peaks.length > length) {
      peaks = peaks.sublist(peaks.length - length);
    }

    var min = peaks[0];
    var max = peaks[0];

    // find min and max
    for (int peak in peaks) {
      if (peak < min) {
        min = peak;
      }
      if (peak > max) {
        max = peak;
      }
    }

    normalizedPeaks.clear();
    // normalize list
    for (int peak in peaks) {
      normalizedPeaks.add((peak - min) / (max - min));
    }

    if (_backgroundState.mounted) {
      _backgroundState.setState(() {});
    }
  }

  void toggleChartVisibility() {
    _backgroundState.setState(() {
      chartVisibility = !chartVisibility;
    });
  }

  @override
  _BackgroundState createState() => _backgroundState;
}

class _BackgroundState extends State<Background> {
  @override
  Widget build(BuildContext context) {
    widget.size = MediaQuery.of(context).size;

    return Container(
      height: widget.size.height,
      width: widget.size.width,
      color: Theme.of(context).accentColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Visibility(
            visible: widget.chartVisibility,
            child: CustomPaint(
              size: Size(widget.size.width, widget.size.height * 0.2),
              painter:
                  CurvePainter(peaks: widget.normalizedPeaks, context: context),
            ),
          ),
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

class CurvePainter extends CustomPainter {
  List<double> peaks;
  BuildContext context;

  CurvePainter({@required this.peaks, @required this.context});

  @override
  void paint(Canvas canvas, Size size) {
    var steps = this.peaks.length * 2;
    var stepWidth = size.width / steps;

    Paint paint = Paint()
      ..color = Theme.of(context).primaryColor
      ..style = PaintingStyle.fill
      ..strokeWidth = 0.0;

    Path path = Path();
    path.moveTo(0.0, size.height);
    path.lineTo(0.0, getHeight(size.height, peaks.first));

    // TODO not right yet
    var counter = 1;
    for (int i = 0; i < peaks.length - 1; i++) {
      var offset = counter + i;
      path.cubicTo(
          stepWidth * (offset + 2),
          getHeight(size.height, peaks[i]),
          stepWidth * (offset + 2),
          getHeight(size.height, peaks[i + 1]),
          stepWidth * (offset + 3),
          getHeight(size.height, peaks[i + 1]));
      counter++;
    }

    path.lineTo(size.width, getHeight(size.height, peaks.last));
    path.lineTo(size.width, size.height);

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  double getHeight(double height, double factor) {
    return height - height * factor;
  }
}
