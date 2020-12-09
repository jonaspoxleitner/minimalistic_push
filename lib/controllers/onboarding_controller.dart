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

  Future<SharedPreferences> setSharedPreferences() async {
    return await SharedPreferences.getInstance()
        .then((value) => this.prefs = value);
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
    this.prefs.setInt('onboarding', version);
  }

  // for debug purposes only
  void returnToOnboarding() {
    this.setOnboardingVersion(0);
    RouteManager.instance.reloadRouteManagerState();
  }

  void acceptOnboarding() {
    this.setOnboardingVersion(this.newestOnboardingVersion);
    RouteManager.instance.reloadRouteManagerState();
  }

  bool showOnboarding() {
    return this.newestOnboardingVersion > this.getOnboardingVersion();
  }
}
