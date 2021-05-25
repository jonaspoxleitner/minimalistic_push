import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// The manager for the data regarding the hardcore mode and the onboarding.
class PreferencesController extends GetxController {
  /// The version of the onboarding version, which can be used to force the
  /// onboarding.
  final int newestOnboardingVersion = 4;

  /// A stream of the value of hardcore.
  final RxBool hardcore = true.obs;

  /// A stream of the value of the onboarding.
  final RxBool onboarding = true.obs;

  /// The constructor of the class, which also initializes the streams.
  PreferencesController() {
    isHardcore();
    isOnboarding();
  }

  /// Publishes the value of hardcore to the stream.
  void isHardcore() async {
    hardcore.value = await getHardcore();
    update();
  }

  /// Returns the value of hardcore from the SharedPreferences.
  bool getHardcore() {
    return GetStorage().read('hardcore') ?? true;
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
  Future<void> _setHardcore(bool hardcore) async {
    await GetStorage().write('hardcore', hardcore);
    isHardcore();
  }

  /// Publishes the onboarding state to the stream.
  void isOnboarding() {
    onboarding.value = newestOnboardingVersion > getOnboardingVersion();
    update();
  }

  /// Returns the already accepted onboarding version.
  int getOnboardingVersion() {
    return GetStorage().read('onboarding') ?? 0;
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
  Future<void> _setOnboardingVersion(int version) async {
    await GetStorage().write('onboarding', version);
    isOnboarding();
  }
}
