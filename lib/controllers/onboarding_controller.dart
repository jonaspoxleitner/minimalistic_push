import 'package:minimalisticpush/screens/screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingController {
  var prefs;

  static OnboardingController _instance;
  static get instance {
    if (_instance == null) {
      _instance = OnboardingController._internal();
    }

    return _instance;
  }

  OnboardingController._internal();

  Future<SharedPreferences> setSharedPreferences() async {
    this.prefs = await SharedPreferences.getInstance();

    // TODO make nice
    Screen.instance.onboardingVersion = this.getOnboardingVersion();

    return this.prefs;
  }

  int getOnboardingVersion() {
    var version = prefs.getInt('onboarding');

    if (version == null) {
      setOnboardingVersion(0);
      return 0;
    }

    return version;
  }

  void setOnboardingVersion(int version) {
    prefs.setInt('onboarding', version);
  }

  // for debug purposes only
  void returnToOnboarding() {
    OnboardingController.instance.setOnboardingVersion(0);
    Screen.instance.setOnboardingVersion(0);
  }
}
