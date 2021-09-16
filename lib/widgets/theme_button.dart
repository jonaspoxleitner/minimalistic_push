import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:minimalistic_push/styles/styles.dart';

/// The button for the theme selection in the settings.
class ThemeButton extends StatelessWidget {
  /// The AppTheme.
  final AppTheme theme;

  /// If the theme is currently selected.
  final bool isCurrent;

  /// The constructor.
  const ThemeButton({
    Key? key,
    required this.theme,
    required this.isCurrent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    final height = 70.0;

    return GestureDetector(
      onTap: () {
        Get.changeTheme(theme.data);
        GetStorage().write('theme', theme.id);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(color: theme.data.accentColor),
                width: width,
                height: height,
              ),
              CustomPaint(
                painter: _DiagonalPainter(color: theme.data.primaryColor),
                size: Size(width, height),
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
                  theme.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18.0, color: Colors.white),
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
  final Color color;

  const _DiagonalPainter({required this.color});

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
