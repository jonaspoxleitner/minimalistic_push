import 'package:flutter/material.dart';

import 'package:minimalisticpush/widgets/location_text.dart';

class NavigationBar extends StatelessWidget {
  const NavigationBar({
    @required this.text,
    this.leftOption,
    this.rightOption,
  });

  final String text;
  final NavigationOption leftOption;
  final NavigationOption rightOption;

  @override
  Widget build(BuildContext context) {
    List<Widget> options = [];

    if (leftOption != null) {
      options.add(leftOption);
    }

    options.add(Spacer());

    if (rightOption != null) {
      options.add(rightOption);
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        LocationText(
          text: this.text,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: options,
        )
      ],
    );
  }
}

class NavigationOption extends StatelessWidget {
  const NavigationOption({
    @required this.icon,
    @required this.onPressed,
  });

  final IconData icon;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: const EdgeInsets.all(16.0),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      icon: Icon(
        this.icon,
        color: Colors.white,
      ),
      onPressed: onPressed,
    );
  }
}
