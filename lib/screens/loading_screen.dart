import 'package:flutter/material.dart';
import 'package:minimalisticpush/models/custom_colors.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomColors.green,
      height: 40,
      width: 40,
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
