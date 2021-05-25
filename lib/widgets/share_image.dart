import 'package:flutter/material.dart';

/// The image, which will be shared.
class ShareImage extends StatelessWidget {
  /// The constructor.
  const ShareImage({
    Key? key,
    required this.primaryColor,
    required this.accentColor,
    required this.size,
    required this.peaks,
  }) : super(key: key);

  /// The primary color.
  final Color primaryColor;

  /// The accent color.
  final Color accentColor;

  /// The size of the widget/image.
  final Size size;

  /// The list with the normalized peaks.
  final List<double> peaks;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: accentColor,
      child: CustomPaint(
        size: Size(size.width, size.height),
        painter: _SharePainter(
          peaks: peaks,
          size: size,
          context: context,
          color: primaryColor,
        ),
      ),
    );
  }
}

class _SharePainter extends CustomPainter {
  const _SharePainter({
    required this.peaks,
    required this.size,
    required this.context,
    required this.color,
  });

  final List<double> peaks;
  final Size size;
  final BuildContext context;
  final Color color;
  final topBottomPadding = 50;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 0.0
      ..color = color;

    var steps = peaks.length * 2 - 2;
    var stepWidth = this.size.width / steps;

    var path = Path();
    path.moveTo(0.0, size.height);
    path.lineTo(0.0, getHeight(peaks.first));

    var offset = 0;
    for (var i = 0; i < peaks.length - 1; i++) {
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
    var height = size.height - (2 * topBottomPadding);
    return (height - height * factor) + topBottomPadding;
  }
}
