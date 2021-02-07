import 'package:flutter/material.dart';
import 'package:minimalisticpush/localizations.dart';

import 'package:minimalisticpush/screens/error_screen.dart';
import 'package:minimalisticpush/screens/sessions_content.dart';
import 'package:minimalisticpush/screens/settings_content.dart';
import 'package:minimalisticpush/utils/share_image.dart';
import 'package:minimalisticpush/widgets/background.dart';
import 'package:minimalisticpush/widgets/navigation_bar.dart';

class NamedOverlayRoute extends OverlayRoute {
  final ValueNotifier<double> opacityNotifier;
  final String overlayName;
  CustomOverlayEntry current;

  NamedOverlayRoute({
    @required this.opacityNotifier,
    @required this.overlayName,
  });

  void _close() {
    this.opacityNotifier.value = 1.0;
    Background.instance.factorNotifier.value = 0.6;
    current.close();
  }

  // sets the underlying state to invisible and animates the background to 1.0
  @override
  TickerFuture didPush() {
    this.opacityNotifier.value = 0.0;
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
                child: SessionsScreen(),
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
                child: SettingsScreen(),
              );
              break;
            default:
              current = CustomOverlayEntry(
                navigationBar: NavigationBar(
                  text: 'Error',
                ),
                child: ErrorScreen(),
              );
              break;
          }

          return current;
        },
      )
    ];
  }
}

// TODO: remove state and animationcontroller with ValueNotifier
class CustomOverlayEntry extends StatefulWidget {
  _CustomOverlayEntryState state = _CustomOverlayEntryState();

  CustomOverlayEntry({
    key,
    @required this.navigationBar,
    @required this.child,
  }) : super(key: key);

  final NavigationBar navigationBar;
  final Widget child;

  void close() {
    state.close();
  }

  @override
  _CustomOverlayEntryState createState() => state;
}

class _CustomOverlayEntryState extends State<CustomOverlayEntry>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  // this function is called to close the overlay and start the animation
  void close() async {
    animationController
        .animateTo(0.0, curve: Curves.easeInOutQuart)
        .then((value) => Navigator.of(context).pop());
  }

  @override
  void initState() {
    animationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    animationController.animateTo(
      1.0,
      curve: Curves.easeInOutQuart,
    );

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnimatedBuilder(
        animation: animationController,
        builder: (context, child) {
          var height = MediaQuery.of(context).size.height;
          var offset = height - animationController.value * height;
          return Transform.translate(
            offset: Offset(0.0, offset),
            child: child,
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

// class MyOverlayScreen extends StatefulWidget {
//   const MyOverlayScreen({
//     @required this.child,
//   });

//   final Widget child;

//   @override
//   _MyOverlayScreenState createState() => _MyOverlayScreenState();
// }

// class _MyOverlayScreenState extends State<MyOverlayScreen>
//     with SingleTickerProviderStateMixin {
//   AnimationController _animationController;

//   // this function is called to close the overlay and start the animation
//   void _close() async {
//     _animationController
//         .animateTo(0, curve: Curves.easeInOutQuart)
//         .then((value) => Navigator.of(context).pop());
//     // animation of the underlying will get rid of this timer
//     Timer(
//       Duration(milliseconds: 200),
//       () => Background.instance.factorNotifier.value = 0.6,
//     );
//   }

//   @override
//   void initState() {
//     _animationController = AnimationController(
//       duration: Duration(milliseconds: 500),
//       vsync: this,
//     );

//     _animationController.animateTo(
//       1,
//       curve: Curves.easeInOutQuart,
//     );

//     super.initState();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: AnimatedBuilder(
//         animation: _animationController,
//         child: SafeArea(
//           bottom: false,
//           child: widget.child,
//         ),
//         builder: (context, child) {
//           var height = MediaQuery.of(context).size.height;
//           var offset = height - _animationController.value * height;
//           return Transform.translate(
//             offset: Offset(0.0, offset),
//             child: child,
//           );
//         },
//       ),
//     );
//   }
// }
