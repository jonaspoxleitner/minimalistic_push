import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'localizations.dart';
import 'managers/background_controller.dart';
import 'managers/preferences_controller.dart';
import 'managers/session_controller.dart';
import 'screens/route_manager.dart';
import 'styles/styles.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  GetStorage().writeIfNull('theme', 'outdoor');

  Get
    ..put(BackgroundController())
    ..put(PreferencesController())
    ..put(SessionController());

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(MinimalisticPush());
}

/// The application.
class MinimalisticPush extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
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
      home: RouteManager(),
    );
  }
}
