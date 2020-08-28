import 'package:flutter/material.dart';

import 'package:after_layout/after_layout.dart';

import '../models/custom_colors.dart';

class Background extends StatefulWidget {
  final _BackgroundState _backgroundState = _BackgroundState();

  Background();

  void animateTo(double factor) {
    if (factor < 0.0) {
      factor = 0.0;
    } else if (factor > 1.0) {
      factor = 1.0;
    }

    _backgroundState.setState(() {
      _backgroundState.height = _backgroundState.size.height * factor;
    });
  }

  @override
  _BackgroundState createState() => _backgroundState;
}

class _BackgroundState extends State<Background>
    with AfterLayoutMixin<Background> {
  var size;
  var height = 0.0;

  @override
  void setState(Function fn) => super.setState(fn);

  @override
  void afterFirstLayout(BuildContext context) {
    super.setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Expanded(
      child: Container(
        alignment: Alignment.bottomCenter,
        color: CustomColors.green,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 400),
          curve: Curves.easeInOutQuart,
          height: height,
          color: CustomColors.darkGreen,
        ),
      ),
    );
  }
}
