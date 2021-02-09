import 'package:minimalisticpush/screens/route_manager.dart';

import 'package:shared_preferences/shared_preferences.dart';

// TODO: convert to manager
class PreferencesController {
  int newestOnboardingVersion = 4; // change to force new onboarding
  SharedPreferences prefs;

  static PreferencesController _instance;
  static get instance {
    if (_instance == null) {
      _instance = PreferencesController._internal();
    }
    return _instance;
  }

  PreferencesController._internal();

  // sets the shared preferences
  Future<SharedPreferences> setSharedPreferences() async {
    return await SharedPreferences.getInstance()
        .then((value) => this.prefs = value);
  }

  // returns the already accepted version of the onboarding
  // if no onboarding was accepted it returns 0
  int getOnboardingVersion() {
    return this.prefs.getInt('onboarding') ?? 0;
  }

  // sets a version into the shared preferences
  void setOnboardingVersion(int version) async {
    await this.prefs.setInt('onboarding', version);
  }

  // debug
  // sets the onboarding version to 0 and forces the RouteManager to reload
  void returnToOnboarding() {
    this.setOnboardingVersion(0);
    RouteManager.instance.onboarding.value = true;
  }

  // is called when the user completes the onboarding experience
  // sets the newest version into the shared preferences and reloads
  void acceptOnboarding() {
    this.setOnboardingVersion(this.newestOnboardingVersion);
    RouteManager.instance.onboarding.value = false;
  }

  // returns if the user has accepted the newest onboarding version
  bool showOnboarding() {
    return this.newestOnboardingVersion > this.getOnboardingVersion();
  }

  // returns the value of hardcore, if no value is set, false will return
  bool getHardcore() {
    return this.prefs.getBool('hardcore') ?? false;
  }

  // sets a new value to hardcore
  void setHardcore(bool hardcore) async {
    await this.prefs.setBool('hardcore', hardcore);
  }
}
