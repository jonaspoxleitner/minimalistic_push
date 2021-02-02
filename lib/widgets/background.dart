import 'package:flutter/material.dart';

import 'package:minimalisticpush/controllers/session_controller.dart';

class Background extends StatefulWidget {
  final bool chartVisibility = false;
  final ValueNotifier<double> factorNotifier = ValueNotifier(0.0);

  static Background _instance;

  static get instance {
    if (_instance == null) {
      _instance = Background._internal();
    }

    return _instance;
  }

  Background._internal();

  @override
  _BackgroundState createState() => _BackgroundState();
}

// TODO: optimize, so that only one controller for the peaks is necessary
class _BackgroundState extends State<Background> with TickerProviderStateMixin {
  AnimationController _animationController;
  AnimationController _curveController;
  List<AnimationController> _peakControllers = [];
  final int _curveDuration = 500;
  Stream<List<double>> stream;
  final List<double> normalizedPeaks = [0.0, 0.0, 0.0, 0.0, 0.0];

  @override
  void initState() {
    stream = SessionController.instance.getStream();
    stream.listen((value) {
      this.update(value);
    });

    SessionController.instance.setNormalizedSessions();

    _animationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _animationController.addListener(() => super.setState(() {}));
    _animationController.animateTo(
      widget.factorNotifier.value,
      curve: Curves.easeInOutQuart,
    );

    for (int i = 0; i < 5; i++) {
      _peakControllers.add(AnimationController(
        duration: Duration(milliseconds: _curveDuration),
        vsync: this,
      ));

      _peakControllers[i].animateTo(
        this.normalizedPeaks[i],
        curve: Curves.easeInOut,
      );
    }

    _curveController = AnimationController(
      duration: Duration(milliseconds: _curveDuration),
      vsync: this,
    );
    _curveController.animateTo(
      1.0,
      curve: Curves.easeInOut,
    );

    widget.factorNotifier.addListener(() => _animationController.animateTo(
          widget.factorNotifier.value,
          curve: Curves.easeInOutQuart,
        ));

    super.initState();
  }

  void update(List<double> peaks) async {
    if (peaks != null && peaks.length != 0) {
      this.normalizedPeaks.clear();
      this.normalizedPeaks.addAll(peaks);
      this.setState(() {});
    }
  }

  @override
  void setState(fn) {
    for (int i = 0; i < 5; i++) {
      _peakControllers[i].animateTo(
        this.normalizedPeaks[i],
        curve: Curves.easeInOutQuart,
      );
    }

    _curveController.reset();
    _curveController.animateTo(
      1.0,
      curve: Curves.easeInOutQuart,
    );

    super.setState(fn);
  }

  @override
  void dispose() {
    _animationController.dispose();

    for (AnimationController a in _peakControllers) {
      a.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      constraints: BoxConstraints.expand(),
      color: Theme.of(context).accentColor,
      alignment: Alignment.bottomCenter,
      child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return AnimatedBuilder(
                animation: _curveController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: CurvePainter(
                      peaks: _peakControllers,
                      context: context,
                      factor: _animationController.value,
                    ),
                    size: Size(size.width, size.height),
                  );
                });
          }),
    );
  }
}

class CurvePainter extends CustomPainter {
  Paint _paint = Paint()
    ..style = PaintingStyle.fill
    ..strokeWidth = 0.0;

  var spaceOnTop;

  CurvePainter({
    @required this.peaks,
    @required this.context,
    @required this.factor,
  });

  final List<AnimationController> peaks;
  final BuildContext context;
  final double factor;

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
    path.lineTo(0.0, getHeight(height, peaks.first.value));

    var offset = 0;
    for (int i = 0; i < peaks.length - 1; i++) {
      path.cubicTo(
          stepWidth * (offset + i + 1),
          getHeight(height, peaks[i].value),
          stepWidth * (offset + i + 1),
          getHeight(height, peaks[i + 1].value),
          stepWidth * (offset + i + 2),
          getHeight(height, peaks[i + 1].value));
      offset++;
    }

    path.lineTo(size.width, getHeight(height, peaks.last.value));
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
