import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:minimalistic_push/control/background_controller.dart';
import 'package:minimalistic_push/control/preferences_controller.dart';
import 'package:minimalistic_push/control/session_controller.dart';
import 'package:minimalistic_push/minimalistic_push.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();
  await GetStorage().writeIfNull('theme', 'outdoor');

  Get
    ..put(BackgroundController())
    ..put(PreferencesController())
    ..put(SessionController());

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const MinimalisticPush());
}
