import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:minimalisticpush/controllers/onboarding_controller.dart'; // for debug
import 'package:minimalisticpush/controllers/session_controller.dart'; // for debug
import 'package:minimalisticpush/localizations.dart';
import 'package:minimalisticpush/styles/styles.dart';
import 'package:minimalisticpush/widgets/custom_button.dart';
import 'package:minimalisticpush/widgets/location_text.dart';
import 'package:minimalisticpush/widgets/share_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    Key key,
  }) : super(key: key);

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
                    text: MyLocalizations.of(context)
                        .getLocale('settings')['title'],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // IconButton(
                      //   padding: const EdgeInsets.all(16.0),
                      //   splashColor: Colors.transparent,
                      //   highlightColor: Colors.transparent,
                      //   icon: Icon(
                      //     Icons.import_export,
                      //     color: Colors.white,
                      //   ),
                      //   onPressed: () {
                      //     // import and export functionality
                      //   },
                      // ),
                      Spacer(),
                      IconButton(
                        padding: const EdgeInsets.all(16.0),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        icon: Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                        onPressed: () {
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
                    // SettingsBlock(
                    //   title: 'Debug Settings',
                    //   description:
                    //       'These Settings are only for debug purposes and will likely be removed from the final Application.',
                    //   children: [
                    //     CustomButton(
                    //       text: 'Return to Onboarding (debug)',
                    //       onTap: () {
                    //         Navigator.of(context).pop();
                    //         OnboardingController.instance.returnToOnboarding();
                    //       },
                    //     ),
                    //     CustomButton(
                    //       text: 'Clear database (debug)',
                    //       onTap: () {
                    //         SessionController.instance.clear();
                    //       },
                    //     ),
                    //   ],
                    // ),
                    SettingsBlock(
                      title: MyLocalizations.of(context)
                          .getLocale('settings')['themes']['title'],
                      description: MyLocalizations.of(context)
                          .getLocale('settings')['themes']['description'],
                      children: AppThemes.getThemeButtons(context),
                    ),
                    CustomButton(
                      text: MyLocalizations.of(context)
                              .getLocale('settings')['about'] +
                          ' ' +
                          MyLocalizations.of(context).getLocale('title'),
                      onTap: () {
                        showLicensePage(
                          context: context,
                          applicationName:
                              MyLocalizations.of(context).getLocale('title'),
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
                                MyLocalizations.of(context)
                                    .getLocale('settings')['thanks'],
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
                          applicationLegalese: '2020 Jonas Poxleitner',
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
