import 'package:flutter/material.dart';
import 'package:minimalisticpush/controllers/controllers.dart';
import 'package:minimalisticpush/screens/main_screen.dart';
import 'package:minimalisticpush/screens/screens.dart';
import 'package:minimalisticpush/widgets/widgets.dart';

class SessionsOverlayRoute extends OverlayRoute {
  MainScreenState underlyingState;
  Widget child;
  List<Widget> sessionWidgets;

  SessionsOverlayRoute(
      {@required this.underlyingState,
      this.child,
      @required this.sessionWidgets});

  @override
  Iterable<OverlayEntry> createOverlayEntries() {
    return [
      new OverlayEntry(builder: (context) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            alignment: Alignment.topCenter,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      LocationText(
                        text: 'Settings/Debug',
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            icon: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              this.underlyingState.setVisibility(true);
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      )
                    ],
                  ),
                  Expanded(
                    child: ListView(
                      children: sessionWidgets,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      })
    ];
  }
}
