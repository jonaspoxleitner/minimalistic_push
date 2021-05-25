import 'dart:async';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../localizations.dart';
import '../managers/preferences_controller.dart';
import '../managers/session_controller.dart';
import '../styles/styles.dart';
import '../widgets/custom_button.dart';

/// The settings content for the overlay route.
class SettingsContent extends StatelessWidget {
  /// The constructor.
  const SettingsContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    var widgets = <Widget>[
      Container(padding: const EdgeInsets.only(top: 70.0)),
      _buildThemesBlock(context),
      _buildHardcoreBlock(context),
      _buildBackupBlock(context),
      _buildAboutButton(context),
    ];

    if (!kReleaseMode) {
      widgets.insert(1, _buildDebugBlock(context));
    }

    return ListView(
      physics: BouncingScrollPhysics(),
      children: widgets,
    );
  }

  CustomButton _buildAboutButton(BuildContext context) {
    return CustomButton(
      text: '${MyLocalizations.of(context).values!['settings']['about']} '
          '${MyLocalizations.of(context).values!['title']}',
      onTap: () {
        showLicensePage(
          context: context,
          applicationName: MyLocalizations.of(context).values!['title'],
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
                MyLocalizations.of(context).values!['settings']['thanks'],
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: GestureDetector(
                  onTap: () => launch(
                    'https://github.com/jonaspoxleitner/minimalistic_push',
                    forceSafariVC: false,
                  ),
                  child: Text(
                    MyLocalizations.of(context).values!['settings']
                        ['github button'],
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
    return _SettingsBlock(
      title: MyLocalizations.of(context).values!['settings']['backup']['title'],
      description: MyLocalizations.of(context).values!['settings']['backup']
          ['description'],
      children: [
        CustomButton(
          text: MyLocalizations.of(context).values!['settings']['backup']
              ['import']['title'],
          onTap: () => _showAlertDialog(
              context,
              MyLocalizations.of(context).values!['settings']['backup']
                  ['import']['title'],
              MyLocalizations.of(context).values!['settings']['backup']
                  ['import']['description'],
              [
                TextButton(
                  style: TextButton.styleFrom(
                      primary: Theme.of(context).primaryColor),
                  child: Text(
                    MyLocalizations.of(context).values!['settings']['backup']
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
                    '${MyLocalizations.of(context).values!['settings']['backup']['import']['title']}.',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    FlutterClipboard.paste().then((value) {
                      if (Get.find<SessionController>()
                          .importDataFromString(value)) {
                        _showAlertDialog(
                          context,
                          MyLocalizations.of(context).values!['settings']
                              ['backup']['import']['title'],
                          MyLocalizations.of(context).values!['settings']
                              ['backup']['import']['success'],
                          [
                            TextButton(
                              style: TextButton.styleFrom(
                                  primary: Theme.of(context).primaryColor),
                              child: Text(
                                MyLocalizations.of(context).values!['settings']
                                    ['backup']['okay'],
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
                          MyLocalizations.of(context).values!['settings']
                              ['backup']['import']['title'],
                          MyLocalizations.of(context).values!['settings']
                              ['backup']['import']['fail'],
                          [
                            TextButton(
                              style: TextButton.styleFrom(
                                  primary: Theme.of(context).primaryColor),
                              child: Text(
                                MyLocalizations.of(context).values!['settings']
                                    ['backup']['okay'],
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
          text: MyLocalizations.of(context).values!['settings']['backup']
              ['export']['title'],
          onTap: () {
            var data = Get.find<SessionController>().exportDataToString();
            FlutterClipboard.copy(data).then((value) => _showAlertDialog(
                  context,
                  MyLocalizations.of(context).values!['settings']['backup']
                      ['export']['title'],
                  MyLocalizations.of(context).values!['settings']['backup']
                      ['export']['success'],
                  [
                    TextButton(
                      style: TextButton.styleFrom(
                          primary: Theme.of(context).primaryColor),
                      child: Text(
                        MyLocalizations.of(context).values!['settings']
                            ['backup']['okay'],
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
      title: MyLocalizations.of(context).values!['settings']['hardcore']
          ['title'],
      description: MyLocalizations.of(context).values!['settings']['hardcore']
          ['description'],
      children: [_HardcoreToggle()],
    );
  }

  _SettingsBlock _buildThemesBlock(BuildContext context) {
    return _SettingsBlock(
      title: MyLocalizations.of(context).values!['settings']['themes']['title'],
      description: MyLocalizations.of(context).values!['settings']['themes']
          ['description'],
      children: AppThemes.getThemeButtons(context),
    );
  }

  /// This SettingsBlock is used for debug purposes.
  // ignore: unused_element
  _SettingsBlock _buildDebugBlock(BuildContext context) {
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
            Get.find<PreferencesController>().returnToOnboarding();
          },
        ),
        CustomButton(
          text: 'Clear database (debug)',
          onTap: () {
            Get.find<SessionController>().clear();
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
    return GetBuilder<PreferencesController>(
      builder: (preferencesController) {
        return GestureDetector(
          onTap: () {
            preferencesController.hardcore.isTrue
                ? preferencesController.disableHardcore()
                : preferencesController.enableHardcore();
          },
          child: Icon(
            preferencesController.hardcore.isTrue
                ? Icons.check_box
                : Icons.check_box_outline_blank,
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
    Key? key,
    this.title,
    this.description,
    required this.children,
  }) : super(key: key);

  final String? title;
  final String? description;
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
            description!,
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
            title!,
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
