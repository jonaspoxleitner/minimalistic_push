import 'dart:async';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sprinkle/Observer.dart';
import 'package:sprinkle/sprinkle.dart';
import 'package:url_launcher/url_launcher.dart';

import '../localizations.dart';
import '../managers/preferences_manager.dart';
import '../managers/session_manager.dart';
import '../styles/styles.dart';
import '../widgets/custom_button.dart';

/// The settings content for the overlay route.
class SettingsContent extends StatelessWidget {
  /// The constructor.
  const SettingsContent({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(padding: const EdgeInsets.only(top: 70.0)),
        _buildDebugBlock(context),
        _buildThemesBlock(context),
        _buildHardcoreBlock(context),
        _buildBackupBlock(context),
        _buildAboutButton(context),
      ],
    );
  }

  CustomButton _buildAboutButton(BuildContext context) {
    return CustomButton(
      text: '${MyLocalizations.of(context).getLocale('settings')['about']} '
          '${MyLocalizations.of(context).getLocale('title')}',
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
    );
  }

  _SettingsBlock _buildBackupBlock(BuildContext context) {
    var sessionManager = context.use<SessionManager>();

    return _SettingsBlock(
      title: MyLocalizations.of(context).getLocale('settings')['backup']
          ['title'],
      description: MyLocalizations.of(context).getLocale('settings')['backup']
          ['description'],
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
                    MyLocalizations.of(context).getLocale('settings')['backup']
                        ['cancel'],
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                      primary: Theme.of(context).primaryColor),
                  child: Text(
                    // ignore: lines_longer_than_80_chars
                    '${MyLocalizations.of(context).getLocale('settings')['backup']['import']['title']}.',
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
                                    .getLocale('settings')['backup']['okay'],
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              onPressed: () => Navigator.of(context).pop(),
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
                                    .getLocale('settings')['backup']['okay'],
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              onPressed: () => Navigator.of(context).pop(),
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
                  MyLocalizations.of(context).getLocale('settings')['backup']
                      ['export']['title'],
                  MyLocalizations.of(context).getLocale('settings')['backup']
                      ['export']['success'],
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
    );
  }

  _SettingsBlock _buildHardcoreBlock(BuildContext context) {
    return _SettingsBlock(
      title: MyLocalizations.of(context).getLocale('settings')['hardcore']
          ['title'],
      description: MyLocalizations.of(context).getLocale('settings')['hardcore']
          ['description'],
      children: [_HardcoreToggle()],
    );
  }

  _SettingsBlock _buildThemesBlock(BuildContext context) {
    return _SettingsBlock(
      title: MyLocalizations.of(context).getLocale('settings')['themes']
          ['title'],
      description: MyLocalizations.of(context).getLocale('settings')['themes']
          ['description'],
      children: AppThemes.getThemeButtons(context),
    );
  }

  /// This SettingsBlock is used for debug purposes.
  // ignore: unused_element
  _SettingsBlock _buildDebugBlock(BuildContext context) {
    var sessionManager = context.use<SessionManager>();
    var preferencesManager = context.use<PreferencesManager>();

    return _SettingsBlock(
      title: 'Debug Settings',
      description:
          'These Settings are only for debug purposes and will likely be '
          'removed from the final Application.',
      children: [
        CustomButton(
          text: 'Return to Onboarding (debug)',
          onTap: () {
            Navigator.of(context).pop();
            preferencesManager.returnToOnboarding();
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

  Future<void> _showAlertDialog(BuildContext context, String title,
      String description, List<TextButton> options) async {
    return showDialog<void>(
      context: context,
      builder: (context) {
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

class _HardcoreToggle extends StatelessWidget {
  const _HardcoreToggle({key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var preferencesManager = context.use<PreferencesManager>();

    return Observer<bool>(
      stream: preferencesManager.hardcore,
      builder: (context, value) {
        return GestureDetector(
          onTap: () {
            value
                ? preferencesManager.disableHardcore()
                : preferencesManager.enableHardcore();
          },
          child: Icon(
            value ? Icons.check_box : Icons.check_box_outline_blank,
            size: 30.0,
            color: Colors.white,
          ),
        );
      },
    );
  }
}

// this widget represents a block in the settings
class _SettingsBlock extends StatelessWidget {
  const _SettingsBlock({
    key,
    this.title,
    this.description,
    @required this.children,
  }) : super(key: key);

  final String title;
  final String description;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[];
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
