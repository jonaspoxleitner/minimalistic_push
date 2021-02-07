import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:minimalisticpush/controllers/preferences_controller.dart';
import 'package:minimalisticpush/localizations.dart';
import 'package:minimalisticpush/managers/session_manager.dart';
import 'package:minimalisticpush/styles/styles.dart';
import 'package:minimalisticpush/widgets/custom_button.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:clipboard/clipboard.dart';
import 'package:sprinkle/sprinkle.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    Key key,
  }) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    var sessionManager = context.use<SessionManager>();

    return ListView(
      children: [
        //DebugBlock(),
        SettingsBlock(
          title: MyLocalizations.of(context).getLocale('settings')['themes']
              ['title'],
          description: MyLocalizations.of(context)
              .getLocale('settings')['themes']['description'],
          children: AppThemes.getThemeButtons(context),
        ),
        SettingsBlock(
          title: MyLocalizations.of(context).getLocale('settings')['hardcore']
              ['title'],
          description: MyLocalizations.of(context)
              .getLocale('settings')['hardcore']['description'],
          children: [HardcoreToggle()],
        ),
        SettingsBlock(
          title: MyLocalizations.of(context).getLocale('settings')['backup']
              ['title'],
          description: MyLocalizations.of(context)
              .getLocale('settings')['backup']['description'],
          children: [
            CustomButton(
              text: MyLocalizations.of(context).getLocale('settings')['backup']
                  ['import']['title'],
              onTap: () => _showAlertDialog(
                  context,
                  MyLocalizations.of(context).getLocale('settings')['backup']
                      ['import']['title'],
                  MyLocalizations.of(context).getLocale('settings')['backup']
                      ['import']['description'],
                  [
                    TextButton(
                      style: TextButton.styleFrom(
                          primary: Theme.of(context).primaryColor),
                      child: Text(
                        MyLocalizations.of(context)
                            .getLocale('settings')['backup']['cancel'],
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                          primary: Theme.of(context).primaryColor),
                      child: Text(
                        MyLocalizations.of(context)
                                    .getLocale('settings')['backup']['import']
                                ['title'] +
                            '.',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        FlutterClipboard.paste().then((value) {
                          if (sessionManager.importDataFromString(value)) {
                            _showAlertDialog(
                              context,
                              MyLocalizations.of(context)
                                      .getLocale('settings')['backup']['import']
                                  ['title'],
                              MyLocalizations.of(context)
                                      .getLocale('settings')['backup']['import']
                                  ['success'],
                              [
                                TextButton(
                                  style: TextButton.styleFrom(
                                      primary: Theme.of(context).primaryColor),
                                  child: Text(
                                    MyLocalizations.of(context)
                                            .getLocale('settings')['backup']
                                        ['okay'],
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          } else {
                            _showAlertDialog(
                              context,
                              MyLocalizations.of(context)
                                      .getLocale('settings')['backup']['import']
                                  ['title'],
                              MyLocalizations.of(context)
                                      .getLocale('settings')['backup']['import']
                                  ['fail'],
                              [
                                TextButton(
                                  style: TextButton.styleFrom(
                                      primary: Theme.of(context).primaryColor),
                                  child: Text(
                                    MyLocalizations.of(context)
                                            .getLocale('settings')['backup']
                                        ['okay'],
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          }
                        });
                      },
                    ),
                  ]),
            ),
            CustomButton(
              text: MyLocalizations.of(context).getLocale('settings')['backup']
                  ['export']['title'],
              onTap: () {
                var data = sessionManager.exportDataToString();
                FlutterClipboard.copy(data).then((value) => _showAlertDialog(
                      context,
                      MyLocalizations.of(context)
                          .getLocale('settings')['backup']['export']['title'],
                      MyLocalizations.of(context)
                          .getLocale('settings')['backup']['export']['success'],
                      [
                        TextButton(
                          style: TextButton.styleFrom(
                              primary: Theme.of(context).primaryColor),
                          child: Text(
                            MyLocalizations.of(context)
                                .getLocale('settings')['backup']['okay'],
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ));
              },
            )
          ],
        ),
        CustomButton(
          text: MyLocalizations.of(context).getLocale('settings')['about'] +
              ' ' +
              MyLocalizations.of(context).getLocale('title'),
          onTap: () {
            showLicensePage(
              context: context,
              applicationName: MyLocalizations.of(context).getLocale('title'),
              applicationIcon: Column(
                children: [
                  Container(
                    width: 150.0,
                    height: 150.0,
                    padding: const EdgeInsets.all(16.0),
                    child: Image.asset(
                      'assets/icons/app_icon.png',
                    ),
                  ),
                  Text(
                    MyLocalizations.of(context).getLocale('settings')['thanks'],
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: GestureDetector(
                      onTap: () => launch(
                        'https://github.com/iIDRAGONFIREIi/minimalistic_push',
                        forceSafariVC: false,
                      ),
                      child: Text(
                        MyLocalizations.of(context)
                            .getLocale('settings')['github button'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              applicationLegalese: '2021 Jonas Poxleitner',
            );
          },
        ),
      ],
    );
  }

  Future<void> _showAlertDialog(BuildContext context, String title,
      String description, List<TextButton> options) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  description,
                ),
              ],
            ),
          ),
          actions: options,
        );
      },
    );
  }
}

class DebugBlock extends StatelessWidget {
  const DebugBlock({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var sessionManager = context.use<SessionManager>();

    return SettingsBlock(
      title: 'Debug Settings',
      description:
          'These Settings are only for debug purposes and will likely be removed from the final Application.',
      children: [
        CustomButton(
          text: 'Return to Onboarding (debug)',
          onTap: () {
            Navigator.of(context).pop();
            PreferencesController.instance.returnToOnboarding();
          },
        ),
        CustomButton(
          text: 'Clear database (debug)',
          onTap: () {
            sessionManager.clear();
          },
        ),
      ],
    );
  }
}

class HardcoreToggle extends StatefulWidget {
  @override
  _HardcoreToggleState createState() => _HardcoreToggleState();
}

class _HardcoreToggleState extends State<HardcoreToggle> {
  var hardcore;

  void _buttonPress() {
    this.setState(() {
      this.hardcore = !this.hardcore;
      PreferencesController.instance.setHardcore(this.hardcore);
    });
  }

  @override
  void initState() {
    hardcore = PreferencesController.instance.getHardcore();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _buttonPress,
      child: Icon(
        this.hardcore ? Icons.check_box : Icons.check_box_outline_blank,
        size: 30.0,
        color: Colors.white,
      ),
    );
  }
}

// this widget represents a block in the settings
class SettingsBlock extends StatelessWidget {
  final String title;
  final String description;
  final List<Widget> children;

  SettingsBlock({
    Key key,
    this.title,
    this.description,
    @required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    children.addAll(this.children);

    if (description != null) {
      children.insertAll(0, [
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
      children.insertAll(0, [
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
          children: children,
        ),
      ),
    );
  }
}
