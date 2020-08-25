import 'package:flutter/material.dart';

import '../models/custom_colors.dart';

class Background extends StatelessWidget {
  final Size size;

  Background({@required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height,
      width: size.width,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: size.height,
            color: CustomColors.green,
          ),
          Container(
            height: size.height / 2,
            width: size.width,
            color: CustomColors.darkGreen,
          ),
        ],
      ),
    );
  }
}
