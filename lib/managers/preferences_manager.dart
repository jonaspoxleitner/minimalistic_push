import 'package:shared_preferences/shared_preferences.dart';
import 'package:sprinkle/Manager.dart';
import 'package:sprinkle/sprinkle.dart';

/// The manager for the data regarding the hardcore mode and the onboarding.
class PreferencesManager extends Manager {
  /// The version of the onboarding version, which can be used to force the
  /// onboarding.
  final newestOnboardingVersion = 4;

  /// A stream of the value of hardcore.
  final hardcore = true.reactive;

  /// A stream of the value of the onboarding.
  final onboarding = true.reactive;

  /// The constructor of the class, which also initializes the streams.
  PreferencesManager() {
    isHardcore();
    isOnboarding();
  }

  /// Returns an instance of [SharedPreferences].
  Future<SharedPreferences> get sharedPreferences async =>
      await SharedPreferences.getInstance();

  /// Publishes the value of hardcore to the stream.
  void isHardcore() async {
    hardcore.value = await getHardcore();
  }

  /// Returns the value of hardcore from the SharedPreferences.
  Future<bool> getHardcore() async {
    return sharedPreferences.then((sp) => sp.getBool('hardcore') ?? false);
  }

  /// Enables the hardcore mode.
  void enableHardcore() {
    _setHardcore(true);
  }

  /// Disables the hardcore mode.
  void disableHardcore() {
    _setHardcore(false);
  }

  /// Sets the new mode to the SharedPreferences and updates the UI.
  void _setHardcore(bool hardcore) async {
    await sharedPreferences.then((sp) => sp.setBool('hardcore', hardcore));
    isHardcore();
  }

  /// Publishes the onboarding state to the stream.
  void isOnboarding() async {
    onboarding.value = newestOnboardingVersion > await getOnboardingVersion();
  }

  /// Returns the already accepted onboarding version.
  Future<int> getOnboardingVersion() async {
    return sharedPreferences.then((sp) => sp.getInt('onboarding') ?? 0);
  }

  /// Sets the [newestOnboardingVersion].
  void acceptOnboarding() {
    _setOnboardingVersion(newestOnboardingVersion);
  }

  /// Sets the onboarding version to 0 for debug purposes.
  void returnToOnboarding() {
    _setOnboardingVersion(0);
  }

  /// Sets the onboardingVersion and updates the UI.
  void _setOnboardingVersion(int version) async {
    await sharedPreferences.then((sp) => sp.setInt('onboarding', version));
    isOnboarding();
  }

  @override
  void dispose() {
    hardcore.close();
    onboarding.close();
  }
}
