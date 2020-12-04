import 'package:flutter/material.dart';

import 'package:minimalisticpush/styles/styles.dart';

class InstructionWidget extends StatelessWidget {
  final int number;
  final String text;

  InstructionWidget({this.number, this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 36.0,
              width: 36.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Text(number.toString(),
                  style: TextStyle(
                    color: CustomColors.dark,
                    fontWeight: FontWeight.bold,
                    fontSize: 22.0,
                  )),
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
