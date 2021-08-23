import 'package:flutter/material.dart';

/// The location widget on the top of the screen.
class LocationText extends StatelessWidget {
  /// The text of the location.
  final String text;

  /// The constructor.
  const LocationText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(
              color: Colors.white,
              width: 1.0,
              style: BorderStyle.solid,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w300,
                color: Colors.white,
              ),
              textScaleFactor: 1.0,
            ),
          ),
        ),
      );
}
