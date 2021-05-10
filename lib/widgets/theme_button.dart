import 'package:flutter/material.dart';

import 'package:theme_provider/theme_provider.dart';

/// The button for the theme selection in the settings.
class ThemeButton extends StatelessWidget {
  /// The constructor.
  const ThemeButton({
    key,
    @required this.appTheme,
    @required this.isCurrent,
  }) : super(key: key);

  /// The AppTheme.
  final AppTheme appTheme;

  /// If the theme is currently selected.
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    final height = 70.0;

    return GestureDetector(
      onTap: () {
        ThemeProvider.controllerOf(context).setTheme(appTheme.id);
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
                  color: appTheme.data.accentColor,
                ),
                width: width,
                height: height,
              ),
              CustomPaint(
                painter: _DiagonalPainter(
                  color: appTheme.data.primaryColor,
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
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                ),
                child: Text(
                  appTheme.description,
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

class _DiagonalPainter extends CustomPainter {
  const _DiagonalPainter({
    this.color,
  });

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    var _paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 0.0
      ..color = color;

    var path = Path();

    path.moveTo(size.width, 0.0);
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.close();

    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
