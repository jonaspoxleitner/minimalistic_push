import 'package:curved_animation_controller/curved_animation_controller.dart';
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
    this.factor = factor;
    _backgroundState.animate();
  }

  // normalized sessions get set and the background gets updated
  void setSessions(List<double> normalized) {
    this.normalizedPeaks = normalized;
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

class _BackgroundState extends State<Background> with TickerProviderStateMixin {
  CurvedAnimationController animationController;

  void animate() {
    if (this.mounted) {
      //print('animateTo: ' + widget.factor.toString());
      animationController.animateTo(widget.factor);
    }
  }

  @override
  void initState() {
    super.initState();

    animationController = CurvedAnimationController(
      curve: Curves.easeInOutQuad,
      vsync: this,
      duration: Duration(seconds: 1),
    );

    animationController.addListener(() {
      this.setState(() {});
      //print('curvedAnimationController.value: ' +
      //animationController.value.toString());
    });

    animationController.animateTo(widget.factor);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
        constraints: BoxConstraints.expand(),
        color: Theme.of(context).accentColor,
        alignment: Alignment.bottomCenter,
        child: CustomPaint(
          size: Size(size.width, size.height),
          painter: CurvePainter(
            peaks: widget.normalizedPeaks,
            context: context,
            factor: animationController.value,
          ),
        ));
  }
}

class CurvePainter extends CustomPainter {
  Paint _paint = Paint()
    ..style = PaintingStyle.fill
    ..strokeWidth = 0.0;
  List<double> peaks;
  BuildContext context;
  double factor;

  var spaceOnTop;

  CurvePainter({
    @required this.peaks,
    @required this.context,
    @required this.factor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _paint.color = Theme.of(context).primaryColor;

    var height = size.height * 0.2;
    spaceOnTop = size.height - size.height * (factor);

    var steps = this.peaks.length * 2 - 2;
    var stepWidth = size.width / steps;

    if (spaceOnTop >= size.height * 0.8) {
      height = size.height - spaceOnTop;
    } else if (spaceOnTop <= size.height * 0.2) {
      height = spaceOnTop;
    }

    Path path = Path();
    path.moveTo(0.0, size.height);
    path.lineTo(0.0, getHeight(height, peaks.first));

    var offset = 0;
    for (int i = 0; i < peaks.length - 1; i++) {
      path.cubicTo(
          stepWidth * (offset + i + 1),
          getHeight(height, peaks[i]),
          stepWidth * (offset + i + 1),
          getHeight(height, peaks[i + 1]),
          stepWidth * (offset + i + 2),
          getHeight(height, peaks[i + 1]));
      offset++;
    }

    path.lineTo(size.width, getHeight(height, peaks.last));
    path.lineTo(size.width, size.height);

    path.close();
    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  double getHeight(double height, var factor) {
    return (height - height * factor) + spaceOnTop;
  }
}
