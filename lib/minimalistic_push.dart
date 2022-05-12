import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:minimalistic_push/localizations.dart';
import 'package:minimalistic_push/screens/route_manager.dart';
import 'package:minimalistic_push/styles/styles.dart';

/// The application.
class MinimalisticPush extends StatelessWidget {
  const MinimalisticPush({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => GetMaterialApp(
        localizationsDelegates: [
          const MyLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', ''),
          const Locale('de', ''),
        ],
        title: 'Minimalistic Push',
        debugShowCheckedModeBanner: false,
        theme: AppThemes.getById(GetStorage().read('theme')).data,
        themeMode: ThemeMode.light,
        home: const RouteManager(),
      );
}
