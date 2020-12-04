import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesController {
  var prefs;

  static SharedPreferencesController _instance;
  static get instance {
    if (_instance == null) {
      _instance = SharedPreferencesController._internal();
    }

    return _instance;
  }

  SharedPreferencesController._internal();

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
