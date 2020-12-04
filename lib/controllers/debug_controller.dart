import 'package:minimalisticpush/controllers/shared_preferences_controller.dart';
import 'package:minimalisticpush/screens/screen.dart';

class DebugController {
  static DebugController _instance;
  static get instance {
    if (_instance == null) {
      _instance = DebugController._internal();
    }

    return _instance;
  }

  DebugController._internal();

  // for debug purposes only
  void returnToOnboarding() {
    SharedPreferencesController.instance.setOnboardingVersion(0);
    Screen.instance.setOnboardingVersion(0);
  }
}
