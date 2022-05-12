import 'package:flutter/material.dart';
import 'package:minimalistic_push/widgets/location_text.dart';

/// The custom navigation bar of the app.
class NavigationBar extends StatelessWidget {
  /// The text for the location.
  final String? text;

  /// The left option.
  final NavigationOption? leftOption;

  /// The right option.
  final NavigationOption? rightOption;

  /// The constructor.
  const NavigationBar({
    Key? key,
    required this.text,
    this.leftOption,
    this.rightOption,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var options = <Widget>[];

    if (leftOption != null) {
      options.add(leftOption!);
    }

    options.add(const Spacer());

    if (rightOption != null) {
      options.add(rightOption!);
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        if (text != null) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0 + 32.0),
            child: LocationText(text: text!),
          ),
        ],
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: options,
        ),
      ],
    );
  }
}

/// The navigation option inside the navigation bar.
class NavigationOption extends StatelessWidget {
  /// The icon for the option.
  final IconData icon;

  /// The event for the press.
  final void Function() onPressed;

  /// The constructor.
  const NavigationOption({
    Key? key,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.white.withOpacity(0.1),
            highlightColor: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(1000.0),
            onTap: onPressed,
            child: Padding(padding: const EdgeInsets.all(8.0), child: Icon(icon, color: Colors.white, size: 24.0)),
          ),
        ),
      );
}
