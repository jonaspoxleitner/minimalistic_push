import 'package:flutter/material.dart';

import 'package:theme_provider/theme_provider.dart';

class ThemeButton extends StatelessWidget {
  const ThemeButton({
    @required this.appTheme,
    @required this.isCurrent,
  });

  final AppTheme appTheme;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final double height = 70;

    return GestureDetector(
      onTap: () {
        ThemeProvider.controllerOf(context).setTheme(this.appTheme.id);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(10.0),
          ),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: this.appTheme.data.accentColor,
                ),
                width: width,
                height: height,
              ),
              CustomPaint(
                painter: DiagonalPainter(
                  color: this.appTheme.data.primaryColor,
                ),
                size: Size(
                  width,
                  height,
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: width,
                height: height,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isCurrent ? Colors.white : Colors.transparent,
                    width: 2.0,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                child: Text(
                  this.appTheme.description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DiagonalPainter extends CustomPainter {
  Paint _paint = Paint()
    ..style = PaintingStyle.fill
    ..strokeWidth = 0.0;

  DiagonalPainter({
    Color color,
  }) {
    _paint.color = color;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();

    path.moveTo(size.width, 0.0);
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.close();

    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
