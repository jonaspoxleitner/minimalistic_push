import 'package:flutter/material.dart';
import 'package:minimalisticpush/screens/main_screen.dart';
import 'package:minimalisticpush/screens/screens.dart';
import 'package:minimalisticpush/widgets/widgets.dart';

class SessionsOverlayRoute extends OverlayRoute {
  MainScreenState underlyingState;
  Widget child;
  List<Widget> sessionWidgets;

  SessionsOverlayRoute({
    @required this.underlyingState,
    this.child,
    @required this.sessionWidgets,
  });

  @override
  Iterable<OverlayEntry> createOverlayEntries() {
    Background.instance.setReadingMode(true);
    Background.instance.setStateIfMounted();

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
                            padding: const EdgeInsets.all(16.0),
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            icon: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              this.underlyingState.setVisibility(true);

                              Background.instance.setReadingMode(false);
                              Background.instance.setStateIfMounted();

                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      )
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, bottom: 16.0),
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(32.0),
                          ),
                        ),
                        child: ListView(
                          children: sessionWidgets,
                        ),
                      ),
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
