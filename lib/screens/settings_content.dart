import 'dart:async';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:minimalistic_push/control/preferences_controller.dart';
import 'package:minimalistic_push/control/session_controller.dart';
import 'package:minimalistic_push/localizations.dart';
import 'package:minimalistic_push/styles/styles.dart';
import 'package:minimalistic_push/widgets/custom_button.dart';
import 'package:url_launcher/url_launcher_string.dart';

/// The settings content for the overlay route.
class SettingsContent extends StatelessWidget {
  /// The constructor.
  const SettingsContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: SafeArea(
        child: Column(
          children: [
            Container(padding: const EdgeInsets.only(top: 70.0)),
            if (!kReleaseMode) _buildDebugBlock(context),
            _buildThemesBlock(context),
            _buildHardcoreBlock(context),
            _buildBackupBlock(context),
            _buildAboutButton(context),
            // _buildLicenseBlock(context),
          ],
        ),
      ),
    );
  }

  // Widget _buildLicenseBlock(BuildContext context) => _SettingsBlock(children: [
  //       FutureBuilder<_LicenseData>(
  //         future: LicenseRegistry.licenses
  //             .fold<_LicenseData>(_LicenseData(), (prev, license) => prev..addLicense(license))
  //             .then((licenseData) => licenseData..sortPackages()),
  //         builder: (context, data) => Column(
  //             children: [
  //               for (var l in data.data!.licenses)
  //               Text(l.),
  //             ],
  //           ),
  //       ),
  //     ]);

  CustomButton _buildAboutButton(BuildContext context) => CustomButton(
        text: '${MyLocalizations.of(context).values!['settings']['about']} '
            '${MyLocalizations.of(context).values!['title']}',
        onTap: () async {
          showLicensePage(
            context: context,
            applicationName: MyLocalizations.of(context).values!['title'],
            applicationIcon: Column(
              children: [
                Container(
                  width: 150.0,
                  height: 150.0,
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset('assets/icons/app_icon.png'),
                ),
                Text(
                  MyLocalizations.of(context).values!['settings']['thanks'],
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: GestureDetector(
                    onTap: () => launchUrlString('https://github.com/jonaspoxleitner/minimalistic_push'),
                    child: Text(
                      MyLocalizations.of(context).values!['settings']['github button'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(decoration: TextDecoration.underline),
                    ),
                  ),
                ),
              ],
            ),
            applicationLegalese: '2021 Jonas Poxleitner',
          );
        },
      );

  _SettingsBlock _buildBackupBlock(BuildContext context) => _SettingsBlock(
        title: MyLocalizations.of(context).values!['settings']['backup']['title'],
        description: MyLocalizations.of(context).values!['settings']['backup']['description'],
        children: [
          CustomButton(
            text: MyLocalizations.of(context).values!['settings']['backup']['import']['title'],
            onTap: () => _showAlertDialog(context, MyLocalizations.of(context).values!['settings']['backup']['import']['title'],
                MyLocalizations.of(context).values!['settings']['backup']['import']['description'], [
              TextButton(
                style: TextButton.styleFrom(primary: Theme.of(context).primaryColor),
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  MyLocalizations.of(context).values!['settings']['backup']['cancel'],
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(primary: Theme.of(context).primaryColor),
                onPressed: () {
                  Navigator.of(context).pop();
                  FlutterClipboard.paste().then((value) {
                    if (Get.find<SessionController>().importDataFromString(value)) {
                      _showAlertDialog(
                        context,
                        MyLocalizations.of(context).values!['settings']['backup']['import']['title'],
                        MyLocalizations.of(context).values!['settings']['backup']['import']['success'],
                        [
                          TextButton(
                            style: TextButton.styleFrom(primary: Theme.of(context).primaryColor),
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              MyLocalizations.of(context).values!['settings']['backup']['okay'],
                              style: TextStyle(color: Theme.of(context).primaryColor),
                            ),
                          ),
                        ],
                      );
                    } else {
                      _showAlertDialog(
                        context,
                        MyLocalizations.of(context).values!['settings']['backup']['import']['title'],
                        MyLocalizations.of(context).values!['settings']['backup']['import']['fail'],
                        [
                          TextButton(
                            style: TextButton.styleFrom(primary: Theme.of(context).primaryColor),
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              MyLocalizations.of(context).values!['settings']['backup']['okay'],
                              style: TextStyle(color: Theme.of(context).primaryColor),
                            ),
                          ),
                        ],
                      );
                    }
                  });
                },
                child: Text(
                  '${MyLocalizations.of(context).values!['settings']['backup']['import']['title']}.',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
            ]),
          ),
          CustomButton(
            text: MyLocalizations.of(context).values!['settings']['backup']['export']['title'],
            onTap: () {
              var data = Get.find<SessionController>().exportDataToString();
              FlutterClipboard.copy(data).then((value) => _showAlertDialog(
                    context,
                    MyLocalizations.of(context).values!['settings']['backup']['export']['title'],
                    MyLocalizations.of(context).values!['settings']['backup']['export']['success'],
                    [
                      TextButton(
                        style: TextButton.styleFrom(primary: Theme.of(context).primaryColor),
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          MyLocalizations.of(context).values!['settings']['backup']['okay'],
                          style: TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ],
                  ));
            },
          ),
        ],
      );

  _SettingsBlock _buildHardcoreBlock(BuildContext context) => _SettingsBlock(
        title: MyLocalizations.of(context).values!['settings']['hardcore']['title'],
        description: MyLocalizations.of(context).values!['settings']['hardcore']['description'],
        children: [const _HardcoreToggle()],
      );

  _SettingsBlock _buildThemesBlock(BuildContext context) => _SettingsBlock(
        title: MyLocalizations.of(context).values!['settings']['themes']['title'],
        description: MyLocalizations.of(context).values!['settings']['themes']['description'],
        children: AppThemes.getThemeButtons(context),
      );

  /// This SettingsBlock is used for debug purposes.
  // ignore: unused_element
  _SettingsBlock _buildDebugBlock(BuildContext context) => _SettingsBlock(
        title: 'Debug Settings',
        description: 'These Settings are only for debug purposes and will likely be '
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
            onTap: () => Get.find<SessionController>().clear(),
          ),
        ],
      );

  Future<void> _showAlertDialog(
    BuildContext context,
    String title,
    String description,
    List<TextButton> options,
  ) async =>
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(description),
              ],
            ),
          ),
          actions: options,
        ),
      );
}

class _HardcoreToggle extends StatelessWidget {
  const _HardcoreToggle({key}) : super(key: key);

  @override
  Widget build(BuildContext context) => GetBuilder<PreferencesController>(
        builder: (preferencesController) => GestureDetector(
          onTap: () =>
              preferencesController.hardcore.isTrue ? preferencesController.disableHardcore() : preferencesController.enableHardcore(),
          child: Icon(
            preferencesController.hardcore.isTrue ? Icons.check_box : Icons.check_box_outline_blank,
            size: 30.0,
            color: Colors.white,
          ),
        ),
      );
}

// this widget represents a block in the settings
class _SettingsBlock extends StatelessWidget {
  final String? title;
  final String? description;
  final List<Widget> children;

  const _SettingsBlock({Key? key, this.title, this.description, required this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            color: Colors.black26.withOpacity(0.1),
          ),
          child: Column(children: [
            if (title != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title!,
                  textAlign: TextAlign.center,
                  style: TextStyles.subHeading,
                ),
              ),
            if (description != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  description!,
                  textAlign: TextAlign.center,
                  style: TextStyles.body,
                ),
              ),
            ...children,
          ]),
        ),
      );
}
