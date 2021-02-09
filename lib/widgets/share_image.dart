import 'package:flutter/material.dart';

class ShareImage extends StatelessWidget {
  const ShareImage({
    key,
    @required this.primaryColor,
    @required this.accentColor,
    @required this.size,
    @required this.peaks,
  }) : super(key: key);

  final Color primaryColor;
  final Color accentColor;
  final Size size;
  final List<double> peaks;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.size.width,
      height: this.size.height,
      color: this.accentColor,
      alignment: Alignment.bottomCenter,
      child: CustomPaint(
        size: Size(size.width, size.height),
        painter: _SharePainter(
          peaks: peaks,
          size: this.size,
          context: context,
          color: this.primaryColor,
        ),
      ),
    );
  }
}

class _SharePainter extends CustomPainter {
  const _SharePainter({
    @required this.peaks,
    @required this.size,
    @required this.context,
    @required this.color,
  });

  final List<double> peaks;
  final Size size;
  final BuildContext context;
  final Color color;
  final topBottomPadding = 50;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 0.0
      ..color = this.color;

    var steps = this.peaks.length * 2 - 2;
    var stepWidth = this.size.width / steps;

    Path path = Path();
    path.moveTo(0.0, size.height);
    path.lineTo(0.0, getHeight(peaks.first));

    var offset = 0;
    for (int i = 0; i < peaks.length - 1; i++) {
      path.cubicTo(
          stepWidth * (offset + i + 1),
          getHeight(peaks[i]),
          stepWidth * (offset + i + 1),
          getHeight(peaks[i + 1]),
          stepWidth * (offset + i + 2),
          getHeight(peaks[i + 1]));
      offset++;
    }

    path.lineTo(size.width, getHeight(peaks.last));
    path.lineTo(size.width, size.height);

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  double getHeight(double factor) {
    var height = this.size.height - (2 * this.topBottomPadding);
    return (height - height * factor) + this.topBottomPadding;
  }
}
