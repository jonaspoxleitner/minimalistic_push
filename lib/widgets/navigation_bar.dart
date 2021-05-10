import 'package:flutter/material.dart';

import 'location_text.dart';

/// The custom navigation bar of the app.
class NavigationBar extends StatelessWidget {
  /// The constructor.
  const NavigationBar({
    key,
    @required this.text,
    this.leftOption,
    this.rightOption,
  }) : super(key: key);

  /// The text for the location.
  final String text;

  /// The left option.
  final NavigationOption leftOption;

  /// The right option.
  final NavigationOption rightOption;

  @override
  Widget build(BuildContext context) {
    var options = <Widget>[];

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
          text: text,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: options,
        )
      ],
    );
  }
}

/// The navigation option inside the navigation bar.
class NavigationOption extends StatelessWidget {
  /// The constructor.
  const NavigationOption({
    key,
    @required this.icon,
    @required this.onPressed,
  }) : super(key: key);

  /// The icon for the option.
  final IconData icon;

  /// The event for the press.
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: const EdgeInsets.all(16.0),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      icon: Icon(
        icon,
        color: Colors.white,
      ),
      onPressed: onPressed,
    );
  }
}
