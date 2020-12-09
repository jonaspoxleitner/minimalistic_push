import 'package:flutter/material.dart';

class Background extends StatefulWidget {
  var chartVisibility = false;
  var size;
  var height = 0.0;
  List<double> normalizedPeaks = [];
  var padding = EdgeInsets.all(16.0);

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

  // this animates the height of the darker portion between 0 and 100 percent
  void animateTo(double factor) {
    height = size.height * factor * 0.8;
    if (_backgroundState.mounted) {
      _backgroundState.setState(() {});
    }
  }

  // focuses the darker portion with padding
  void focus(bool focus) {
    if (focus) {
      padding = EdgeInsets.all(0.0);
    } else {
      padding = EdgeInsets.all(16.0);
    }

    if (_backgroundState.mounted) {
      _backgroundState.setState(() {});
    }
  }

  // normalized sessions get set and the background gets updated
  void setSessions(List<double> normalized) {
    this.normalizedPeaks = normalized;

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
      child: AnimatedPadding(
        padding: widget.padding,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOutQuart,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Visibility(
              visible: widget.chartVisibility,
              child: CustomPaint(
                size: Size(widget.size.width, widget.size.height * 0.2),
                painter: CurvePainter(
                    peaks: widget.normalizedPeaks, context: context),
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 400),
              curve: Curves.easeInOutQuart,
              height: widget.height,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8.0),
                  bottomRight: Radius.circular(8.0),
                ),
              ),
            ),
          ],
        ),
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
    var steps = this.peaks.length * 2 - 2;
    var stepWidth = size.width / steps;

    Paint paint = Paint()
      ..color = Theme.of(context).primaryColor
      ..style = PaintingStyle.fill
      ..strokeWidth = 0.0;

    Path path = Path();
    path.moveTo(0.0, size.height);
    path.lineTo(0.0, getHeight(size.height, peaks.first));

    var offset = 0;
    for (int i = 0; i < peaks.length - 1; i++) {
      path.cubicTo(
          stepWidth * (offset + i + 1),
          getHeight(size.height, peaks[i]),
          stepWidth * (offset + i + 1),
          getHeight(size.height, peaks[i + 1]),
          stepWidth * (offset + i + 2),
          getHeight(size.height, peaks[i + 1]));
      offset++;
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
