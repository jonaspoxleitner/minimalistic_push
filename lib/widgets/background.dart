import 'package:flutter/material.dart';

import 'package:after_layout/after_layout.dart';

import '../models/custom_colors.dart';

class Background extends StatefulWidget {
  final Size size;

  Background({@required this.size});

  @override
  _BackgroundState createState() => _BackgroundState();
}

class _BackgroundState extends State<Background>
    with AfterLayoutMixin<Background> {
  var height = 0.0;

  @override
  void afterFirstLayout(BuildContext context) {
    height = widget.size.height / 2;
    super.setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.size.height,
      width: widget.size.width,
      alignment: Alignment.bottomCenter,
      color: CustomColors.green,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOutQuart,
        height: height,
        width: widget.size.width,
        color: CustomColors.darkGreen,
      ),
    );
  }
}
