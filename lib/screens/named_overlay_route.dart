import 'dart:async';

import 'package:flutter/material.dart';

import 'package:minimalisticpush/localizations.dart';
import 'package:minimalisticpush/screens/error_screen.dart';
import 'package:minimalisticpush/screens/sessions_content.dart';
import 'package:minimalisticpush/screens/settings_content.dart';
import 'package:minimalisticpush/utils/share_image.dart';
import 'package:minimalisticpush/widgets/background.dart';
import 'package:minimalisticpush/widgets/navigation_bar.dart';

class NamedOverlayRoute extends OverlayRoute {
  final ValueNotifier<double> animationNotifier;
  final String overlayName;

  NamedOverlayRoute({
    @required this.overlayName,
    @required this.animationNotifier,
  });

  // closes the overlay by notifying the animations
  void _close() async {
    this.animationNotifier.value = 0.0;
    Timer(Duration(milliseconds: 250), () {
      Background.instance.factorNotifier.value = 0.6;
    });
  }

  // sets the underlying state to invisible and animates the background to 1.0
  @override
  TickerFuture didPush() {
    this.animationNotifier.value = 1.0;
    Background.instance.factorNotifier.value = 1.0;
    return super.didPush();
  }

  // sets the underlying state to visible and animates the background to 0.5
  @override
  bool didPop(result) {
    return super.didPop(result);
  }

  @override
  Iterable<OverlayEntry> createOverlayEntries() {
    Background.instance.factorNotifier.value = 1.0;

    return [
      new OverlayEntry(
        builder: (context) {
          CustomOverlayEntry current;

          switch (overlayName) {
            case 'sessions':
              current = CustomOverlayEntry(
                navigationBar: NavigationBar(
                  text: MyLocalizations.of(context)
                      .getLocale('sessions')['title'],
                  leftOption: NavigationOption(
                    icon: Icons.reply,
                    onPressed: () => callShareImage(context),
                  ),
                  rightOption: NavigationOption(
                    icon: Icons.close,
                    onPressed: () => _close(),
                  ),
                ),
                child: SessionsContent(),
                animationNotifier: animationNotifier,
              );
              break;
            case 'settings':
              current = CustomOverlayEntry(
                navigationBar: NavigationBar(
                  text: MyLocalizations.of(context)
                      .getLocale('settings')['title'],
                  rightOption: NavigationOption(
                    icon: Icons.close,
                    onPressed: () => _close(),
                  ),
                ),
                child: SettingsContent(),
                animationNotifier: animationNotifier,
              );
              break;
            default:
              current = CustomOverlayEntry(
                navigationBar: NavigationBar(
                  text: 'Error',
                ),
                child: ErrorScreen(),
                animationNotifier: animationNotifier,
              );
              break;
          }

          return current;
        },
      )
    ];
  }
}

class CustomOverlayEntry extends StatefulWidget {
  CustomOverlayEntry(
      {key,
      @required this.navigationBar,
      @required this.child,
      @required this.animationNotifier})
      : super(key: key);

  final NavigationBar navigationBar;
  final Widget child;
  final ValueNotifier<double> animationNotifier;

  @override
  _CustomOverlayEntryState createState() => _CustomOverlayEntryState();
}

class _CustomOverlayEntryState extends State<CustomOverlayEntry>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  void _close() {
    _animationController
        .animateTo(
          widget.animationNotifier.value,
          curve: Curves.easeInOutQuart,
        )
        .then((value) => Navigator.of(context).pop());
  }

  @override
  void initState() {
    _animationController = AnimationController(
      duration: Duration(milliseconds: 750),
      vsync: this,
    );

    _animationController.animateTo(
      widget.animationNotifier.value,
      curve: Curves.easeInOutQuart,
    );

    widget.animationNotifier.addListener(_close);

    super.initState();
  }

  @override
  void dispose() {
    widget.animationNotifier.removeListener(_close);
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          var height = MediaQuery.of(context).size.height;
          var offset = height - _animationController.value * height;
          return Opacity(
            opacity: _animationController.value,
            child: Transform.translate(
              offset: Offset(0.0, offset),
              child: child,
            ),
          );
        },
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              this.widget.navigationBar,
              Expanded(
                child: this.widget.child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
