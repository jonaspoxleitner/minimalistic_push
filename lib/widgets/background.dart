import 'package:flutter/material.dart';

class Background extends StatefulWidget {
  var chartVisibility = false;
  var factor = 0.0;
  bool readingMode = false;
  List<double> normalizedPeaks = [];
  double padding = 16.0;

  static final _BackgroundState _backgroundState = _BackgroundState();

  static Background _instance;
  static get instance {
    if (_instance == null) {
      _instance = Background._internal();
    }

    return _instance;
  }

  Background._internal();

  // this animates the height of the darker portion between 0 and 100 percent
  void animateTo(double factor) {
    this.factor = factor * 0.8;
  }

  // normalized sessions get set and the background gets updated
  void setSessions(List<double> normalized) {
    this.normalizedPeaks = normalized;
    this.setStateIfMounted();
  }

  // set a new visibility for the chart
  void setChartVisibility(bool visibility) {
    this.chartVisibility = visibility;
  }

  // debug
  // toogle the visibility of the chart
  void toggleChartVisibility() {
    this.chartVisibility = !this.chartVisibility;
    this.setStateIfMounted();
  }

  // only sets state if the background is mounted
  void setStateIfMounted() {
    if (_backgroundState.mounted) {
      _backgroundState.setState(() {});
    }
  }

  @override
  _BackgroundState createState() => _backgroundState;
}

class _BackgroundState extends State<Background> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      constraints: BoxConstraints.expand(),
      color: Theme.of(context).accentColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Visibility(
            visible: widget.chartVisibility,
            child: CustomPaint(
              size: Size(size.width, size.height * 0.2),
              painter:
                  CurvePainter(peaks: widget.normalizedPeaks, context: context),
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 400),
            curve: Curves.easeInOutQuart,
            height: size.height * widget.factor,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(2.0 * widget.padding),
                bottomRight: Radius.circular(2.0 * widget.padding),
              ),
            ),
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
