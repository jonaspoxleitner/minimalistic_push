import 'package:shared_preferences/shared_preferences.dart';
import 'package:sprinkle/Manager.dart';
import 'package:sprinkle/sprinkle.dart';

class PreferencesManager extends Manager {
  final int newestOnboardingVersion = 4; // change to force new onboarding
  SharedPreferences prefs;

  final hardcore = true.reactive;
  final onboarding = true.reactive;

  PreferencesManager() {
    setSharedPreferences();
  }

  // sets the shared preferences
  void setSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    isHardcore();
    isOnboarding();
  }

  // publishes to the stream if hardcore is enabled
  void isHardcore() {
    hardcore.value = getHardcore();
  }

  // returns the value of hardcore, if no value is set, false will return
  bool getHardcore() {
    return prefs.getBool('hardcore') ?? false;
  }

  // sets a new value to hardcore
  void setHardcore(bool hardcore) async {
    await prefs.setBool('hardcore', hardcore);
    isHardcore();
  }

  // publishes to the stream if onboarding should be shown
  void isOnboarding() {
    onboarding.value = newestOnboardingVersion > getOnboardingVersion();
  }

  // returns the already accepted version of the onboarding
  // if no onboarding was accepted it returns 0
  int getOnboardingVersion() {
    return prefs.getInt('onboarding') ?? 0;
  }

  // is called when the user completes the onboarding experience
  // sets the newest version into the shared preferences and reloads
  void acceptOnboarding() {
    _setOnboardingVersion(newestOnboardingVersion);
  }

  // debug
  // sets the onboarding version to 0 and forces the RouteManager to reload
  void returnToOnboarding() {
    _setOnboardingVersion(0);
  }

  // debug
  // sets a version into the shared preferences
  void _setOnboardingVersion(int version) async {
    await prefs.setInt('onboarding', version);
    isOnboarding();
  }

  @override
  void dispose() {
    hardcore.close();
    onboarding.close();
  }
}
