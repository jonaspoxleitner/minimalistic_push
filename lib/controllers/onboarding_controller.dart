import 'package:minimalisticpush/screens/route_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingController {
  int newestOnboardingVersion = 2; // change to force new onboarding
  SharedPreferences prefs;

  static OnboardingController _instance;
  static get instance {
    if (_instance == null) {
      _instance = OnboardingController._internal();
    }
    return _instance;
  }

  OnboardingController._internal();

  // sets the shared preferences
  Future<SharedPreferences> setSharedPreferences() async {
    return await SharedPreferences.getInstance()
        .then((value) => this.prefs = value);
  }

  // returns the already accepted version of the onboarding
  // if no onboarding was accepted it returns 0
  int getOnboardingVersion() {
    return prefs.getInt('onboarding') ?? 0;
  }

  // sets a version into the shared preferences
  void setOnboardingVersion(int version) {
    this.prefs.setInt('onboarding', version);
  }

  // debug
  // sets the onboarding version to 0 and forces the RouteManager to reload
  void returnToOnboarding() {
    this.setOnboardingVersion(0);
    RouteManager.instance.reloadRouteManagerState();
  }

  // is called when the user completes the onboarding experience
  // sets the newest version into the shared preferences and reloads
  void acceptOnboarding() {
    this.setOnboardingVersion(this.newestOnboardingVersion);
    RouteManager.instance.reloadRouteManagerState();
  }

  // returns if the user has accepted the newest onboarding version
  bool showOnboarding() {
    return this.newestOnboardingVersion > this.getOnboardingVersion();
  }
}
