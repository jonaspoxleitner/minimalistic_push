import 'package:flutter/material.dart';

import 'package:minimalisticpush/styles/styles.dart';

class BenefitWidget extends StatelessWidget {
  final IconData iconData;
  final String text;

  BenefitWidget({this.iconData, this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Icon(
              iconData,
              color: Colors.white,
              size: 36.0,
            ),
          ),
          Flexible(
            child: Text(
              text,
              softWrap: true,
              style: TextStyles.body,
            ),
          ),
        ],
      ),
    );
  }
}
