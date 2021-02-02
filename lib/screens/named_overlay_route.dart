import 'package:flutter/material.dart';

import 'package:minimalisticpush/screens/error_screen.dart';
import 'package:minimalisticpush/screens/sessions_route.dart';
import 'package:minimalisticpush/screens/settings_route.dart';
import 'package:minimalisticpush/widgets/background.dart';

class NamedOverlayRoute extends OverlayRoute {
  final ValueNotifier<double> opacityNotifier;
  final String overlayName;

  NamedOverlayRoute({
    @required this.opacityNotifier,
    @required this.overlayName,
  });

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
    this.opacityNotifier.value = 1.0;
    Background.instance.factorNotifier.value = 0.6;
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
              return SessionsScreen();
              break;
            case 'settings':
              return SettingsScreen();
              break;
            default:
              return ErrorScreen();
              break;
          }
        },
      )
    ];
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
