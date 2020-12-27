import 'package:flutter/material.dart';
import 'package:minimalisticpush/screens/error_screen.dart';
import 'package:minimalisticpush/screens/main_screen.dart';
import 'package:minimalisticpush/screens/sessions_route.dart';
import 'package:minimalisticpush/screens/settings_route.dart';
import 'package:minimalisticpush/widgets/background.dart';

class NamedOverlayRoute extends OverlayRoute {
  MainScreenState underlyingState;
  String overlayName;

  NamedOverlayRoute({
    @required this.underlyingState,
    @required this.overlayName,
  });

  // sets the underlying state to invisible and animates the background to 1.0
  @override
  TickerFuture didPush() {
    this.underlyingState.setVisibility(false);
    Background.instance.animateTo(1.0);
    Background.instance.setStateIfMounted();
    return super.didPush();
  }

  // sets the underlying state to visible and animates the background to 0.5
  @override
  bool didPop(result) {
    this.underlyingState.setVisibility(true);
    Background.instance.animateTo(0.6);
    Background.instance.setStateIfMounted();
    return super.didPop(result);
  }

  @override
  Iterable<OverlayEntry> createOverlayEntries() {
    Background.instance.animateTo(1.0);
    Background.instance.setStateIfMounted();

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
