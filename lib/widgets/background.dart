import 'package:flutter/material.dart';

import '../models/custom_colors.dart';

import '../screens/screens.dart';

class Background extends StatefulWidget {
  var size;
  var height = 0.0;

  static final _BackgroundState _backgroundState = _BackgroundState();

  Background();

  void animateTo(double factor) {
    if (factor < 0.0) {
      factor = 0.0;
    } else if (factor > 1.0) {
      factor = 1.0;
    }

    //height = size.height * factor;
    _backgroundState.setState(() {
      height = size.height * factor;
    });
  }

  @override
  _BackgroundState createState() => _backgroundState;
}

class _BackgroundState extends State<Background> {
  @override
  void initState() {
    print('init state background');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.size = MediaQuery.of(context).size;

    return Container(
      height: widget.size.height,
      width: widget.size.width,
      alignment: Alignment.bottomCenter,
      color: CustomColors.green,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOutQuart,
        height: widget.height,
        color: CustomColors.darkGreen,
      ),
    );
  }
}
