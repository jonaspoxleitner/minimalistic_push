import 'package:flutter/material.dart';
import 'package:minimalisticpush/controllers/onboarding_controller.dart';
import 'package:minimalisticpush/controllers/session_controller.dart';
import 'package:minimalisticpush/models/session.dart';
import 'package:minimalisticpush/screens/main_screen.dart';
import 'package:minimalisticpush/screens/screens.dart';
import 'package:minimalisticpush/styles/styles.dart';
import 'package:minimalisticpush/widgets/widgets.dart';
import 'package:theme_provider/theme_provider.dart';

class NamedOverlayRoute extends OverlayRoute {
  MainScreenState underlyingState;
  String overlayName;

  NamedOverlayRoute({
    @required this.underlyingState,
    @required this.overlayName,
  });

  @override
  Iterable<OverlayEntry> createOverlayEntries() {
    Background.instance.animateTo(1.0);
    Background.instance.setStateIfMounted();

    return [
      new OverlayEntry(builder: (context) {
        switch (overlayName) {
          case 'sessions':
            return SessionsScreen(underlyingState: underlyingState);
            break;
          case 'settings':
            return SettingsScreen(underlyingState: underlyingState);
            break;
          default:
            return ErrorScreen();
            break;
        }
      })
    ];
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    Key key,
    @required this.underlyingState,
  }) : super(key: key);

  final MainScreenState underlyingState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
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

                          Background.instance.animateTo(0.5);
                          Background.instance.setStateIfMounted();

                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  )
                ],
              ),
              Expanded(
                child: ListView(
                  children: [
                    SettingsBlock(
                      title: 'Debug Settings',
                      description:
                          'These Settings are only for debug purposes and will likely be removed from the final Application.',
                      children: [
                        CustomButton(
                          text: 'Return to Onboarding (debug)',
                          onTap: () {
                            Background.instance.setStateIfMounted();

                            Navigator.of(context).pop();
                            OnboardingController.instance.returnToOnboarding();
                          },
                        ),
                        CustomButton(
                          text: 'Clear database (debug)',
                          onTap: () {
                            SessionController.instance.clear();
                          },
                        ),
                      ],
                    ),
                    SettingsBlock(
                      title: 'Themes',
                      description: 'Choose a theme.',
                      children: [
                        CustomButton(
                          text: 'green theme',
                          onTap: () {
                            ThemeProvider.controllerOf(context)
                                .setTheme('green_theme');
                          },
                        ),
                        CustomButton(
                          text: 'blue theme',
                          onTap: () {
                            ThemeProvider.controllerOf(context)
                                .setTheme('blue_theme');
                          },
                        ),
                        CustomButton(
                          text: 'red theme',
                          onTap: () {
                            ThemeProvider.controllerOf(context)
                                .setTheme('red_theme');
                          },
                        ),
                      ],
                    ),
                    CustomButton(
                      text: 'About Minimalistic Push',
                      onTap: () {
                        showLicensePage(
                          context: context,
                          applicationName: 'Minimalistic Push',
                          applicationIcon: Container(
                            width: 150.0,
                            height: 150.0,
                            padding: const EdgeInsets.all(16.0),
                            child: Image.asset(
                              'assets/icons/app_icon.png',
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsBlock extends StatelessWidget {
  final String title;
  final String description;
  List<Widget> children;

  SettingsBlock({
    Key key,
    this.title,
    this.description,
    @required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (description != null) {
      this.children.insertAll(0, [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyles.body,
          ),
        ),
      ]);
    }

    if (title != null) {
      this.children.insertAll(0, [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyles.subHeading,
          ),
        ),
      ]);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(16.0),
          ),
          color: Colors.black26.withOpacity(0.1),
        ),
        child: Column(
          children: this.children,
        ),
      ),
    );
  }
}

class SessionsScreen extends StatefulWidget {
  const SessionsScreen({
    Key key,
    @required this.underlyingState,
  }) : super(key: key);

  final MainScreenState underlyingState;

  @override
  _SessionsScreenState createState() => _SessionsScreenState();
}

class _SessionsScreenState extends State<SessionsScreen> {
  @override
  Widget build(BuildContext context) {
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
                    text: 'Sessions',
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
                          this.widget.underlyingState.setVisibility(true);

                          Background.instance.animateTo(0.5);
                          Background.instance.setStateIfMounted();

                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  )
                ],
              ),
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: SessionController.instance.loadSessions(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        print('has data');
                        var sessions = SessionController.instance.getSessions();

                        if (sessions.length == 0) {
                          return Center(
                            child: Text(
                              'You should record a session.',
                              style: TextStyles.body,
                            ),
                          );
                        } else {
                          List<Widget> sessionWidgets = [];

                          for (Session session in sessions) {
                            sessionWidgets.add(
                              SessionWidget(
                                session: session,
                                parentState: this,
                              ),
                            );
                          }

                          return ListView(
                            children: sessionWidgets,
                          );
                        }
                      } else if (snapshot.hasError) {
                        print('error');
                        return ErrorScreen();
                      } else {
                        print('loading');
                        return LoadingScreen();
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
