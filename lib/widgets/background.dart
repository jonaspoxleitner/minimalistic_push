import 'package:flutter/material.dart';

import 'package:minimalisticpush/managers/session_manager.dart';
import 'package:minimalisticpush/models/peaks.dart';

import 'package:sprinkle/Observer.dart';
import 'package:sprinkle/sprinkle.dart';

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

class _BackgroundState extends State<Background> with TickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _animationController.addListener(() => super.setState(() {}));
    _animationController.animateTo(
      widget.factorNotifier.value,
      curve: Curves.easeInOutQuart,
    );

    widget.factorNotifier.addListener(() => _animationController.animateTo(
          widget.factorNotifier.value,
          curve: Curves.easeInOutQuart,
        ));

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var sessionManager = context.use<SessionManager>();

    return Container(
      constraints: BoxConstraints.expand(),
      color: Theme.of(context).accentColor,
      alignment: Alignment.bottomCenter,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Observer<List<double>>(
            stream: sessionManager.normalized,
            builder: (context, value) {
              return new AnimatedPeaks(
                peaks: Peaks(list: value),
                animationController: _animationController,
                duration: Duration(milliseconds: 1000),
                curve: Curves.easeInOutQuart,
              );
            },
          );
        },
      ),
    );
  }
}

class AnimatedPeaks extends ImplicitlyAnimatedWidget {
  final Peaks peaks;
  final AnimationController animationController;

  AnimatedPeaks({
    Key key,
    @required this.peaks,
    @required this.animationController,
    @required Duration duration,
    Curve curve = Curves.linear,
  }) : super(duration: duration, curve: curve, key: key);

  @override
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() =>
      _AnimatedPeaksState();
}

class _AnimatedPeaksState extends AnimatedWidgetBaseState<AnimatedPeaks> {
  PeaksTween _peaksTween;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return CustomPaint(
      painter: CurvePainter(
        peaks: _peaksTween.evaluate(animation),
        context: context,
        factor: widget.animationController.value,
      ),
      size: Size(size.width, size.height),
    );
  }

  @override
  void forEachTween(TweenVisitor visitor) {
    _peaksTween = visitor(_peaksTween, widget.peaks,
        (dynamic value) => new PeaksTween(begin: value));
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

  final Peaks peaks;
  final BuildContext context;
  final double factor;

  @override
  void paint(Canvas canvas, Size size) {
    _paint.color = Theme.of(context).primaryColor;

    var height = size.height * 0.2;
    spaceOnTop = size.height - size.height * (factor);

    var steps = this.peaks.list.length * 2 - 2;
    var stepWidth = size.width / steps;

    if (spaceOnTop >= size.height * 0.8) {
      height = size.height - spaceOnTop;
    } else if (spaceOnTop <= size.height * 0.2) {
      height = spaceOnTop;
    }

    Path path = Path();
    path.moveTo(0.0, size.height);
    path.lineTo(0.0, getHeight(height, peaks.list.first));

    var offset = 0;
    for (int i = 0; i < peaks.list.length - 1; i++) {
      path.cubicTo(
          stepWidth * (offset + i + 1),
          getHeight(height, peaks.list[i]),
          stepWidth * (offset + i + 1),
          getHeight(height, peaks.list[i + 1]),
          stepWidth * (offset + i + 2),
          getHeight(height, peaks.list[i + 1]));
      offset++;
    }

    path.lineTo(size.width, getHeight(height, peaks.list.last));
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
