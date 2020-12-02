import 'package:shared_preferences/shared_preferences.dart';

class OnboardingController {
  var prefs;

  static final OnboardingController _onboardingController =
      OnboardingController._internal();

  factory OnboardingController() {
    return _onboardingController;
  }

  OnboardingController._internal();

  Future<SharedPreferences> setSharedPreferences() async {
    this.prefs = await SharedPreferences.getInstance();
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
}
