import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    key,
    @required this.text,
    @required this.onTap,
  }) : super(key: key);

  final String text;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              constraints: BoxConstraints.tightForFinite(),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(10.0),
                ),
                border: Border.all(
                  color: Colors.white,
                  width: 2.0,
                  style: BorderStyle.solid,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  this.text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
