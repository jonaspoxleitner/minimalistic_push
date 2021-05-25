import 'package:get/get.dart';

/// The background manager for handling the height.
class BackgroundController extends GetxController {
  /// The factor of the height.
  final RxDouble factor = (-1.0).obs;

  // ignore: use_setters_to_change_properties
  /// Set a new factor and notifiy the listeners.
  void updateFactor(double f) async {
    if (factor == -1.0) {
      factor.value = f;
    } else {
      factor.value = f;
      update();
    }
  }
}
