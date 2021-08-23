import 'package:flutter/material.dart';

/// A custom button widget.
class CustomButton extends StatelessWidget {
  /// The text inside the button.
  final String text;

  /// The event, which will be called on tap of the button.
  final void Function() onTap;

  /// The constructor.
  const CustomButton({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: GestureDetector(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    border: Border.all(
                      color: Colors.white,
                      width: 2.0,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                      softWrap: true,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
}
