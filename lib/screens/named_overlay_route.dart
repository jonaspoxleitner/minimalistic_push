import 'dart:ui';

import 'package:davinci/davinci.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../localizations.dart';
import '../managers/background_controller.dart';
import '../managers/session_controller.dart';
import '../widgets/navigation_bar.dart';
import '../widgets/share_image.dart';
import 'error_screen.dart';
import 'sessions_content.dart';
import 'settings_content.dart';

/// This OverlayRoute handles the name and the ValueNotifier for the animation.
class NamedOverlayRoute extends OverlayRoute {
  /// The constructor.
  NamedOverlayRoute({
    required this.overlayName,
    required this.animationNotifier,
    required this.context,
  });

  /// This ValueNotifier handles the animation of the widget.
  final ValueNotifier<double> animationNotifier;

  /// The overlay will be used to change the current Route.
  final String overlayName;

  /// The context.
  final BuildContext context;

  // Closes the overlay by notifying the animations.
  void _close() {
    animationNotifier.value = 0.0;
    Get.find<BackgroundController>().updateFactor(0.6);
  }

  void _init() async {
    animationNotifier.value = 1.0;
    Get.find<BackgroundController>().updateFactor(1.0);
  }

  // Sets the underlying state to invisible and animates the background to 1.0.
  @override
  TickerFuture didPush() {
    _init();
    return super.didPush();
  }

  @override
  Iterable<OverlayEntry> createOverlayEntries() {
    return [
      OverlayEntry(
        builder: (context) {
          _CustomOverlayEntry current;
          switch (overlayName) {
            case 'sessions':
              current = _CustomOverlayEntry(
                navigationBar: NavigationBar(
                  text: MyLocalizations.of(context).values!['sessions']
                      ['title'],
                  leftOption: NavigationOption(
                    icon: Icons.reply,
                    onPressed: () => _callShareImage(
                      context,
                      Get.find<SessionController>().normalized.toList(),
                    ),
                  ),
                  rightOption: NavigationOption(
                    icon: Icons.close,
                    onPressed: _close,
                  ),
                ),
                child: SessionsContent(),
                animationNotifier: animationNotifier,
              );
              break;
            case 'settings':
              current = _CustomOverlayEntry(
                navigationBar: NavigationBar(
                  text: MyLocalizations.of(context).values!['settings']
                      ['title'],
                  rightOption: NavigationOption(
                    icon: Icons.close,
                    onPressed: _close,
                  ),
                ),
                child: SettingsContent(),
                animationNotifier: animationNotifier,
              );
              break;
            default:
              current = _CustomOverlayEntry(
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

class _CustomOverlayEntry extends StatefulWidget {
  const _CustomOverlayEntry({
    key,
    required this.navigationBar,
    required this.child,
    required this.animationNotifier,
  }) : super(key: key);

  final NavigationBar navigationBar;
  final Widget child;
  final ValueNotifier<double> animationNotifier;

  @override
  _CustomOverlayEntryState createState() => _CustomOverlayEntryState();
}

class _CustomOverlayEntryState extends State<_CustomOverlayEntry>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  void _close() async {
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
              child: Stack(
                children: [
                  widget.child,
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      ClipRRect(
                        child: BackdropFilter(
                          filter: (_animationController.value == 1.0)
                              ? ImageFilter.blur(sigmaX: 7, sigmaY: 7)
                              : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                          child: SafeArea(
                              bottom: false, child: widget.navigationBar),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

void _callShareImage(BuildContext context, List<double> peaks) async {
  var size = Size(900.0, 450.0);

  await DavinciCapture.offStage(
    ShareImage(
      primaryColor: Theme.of(context).primaryColor,
      accentColor: Theme.of(context).accentColor,
      size: size,
      peaks: peaks,
    ),
    imageSize: size,
    logicalSize: size,
    fileName: 'curve',
  );
}
