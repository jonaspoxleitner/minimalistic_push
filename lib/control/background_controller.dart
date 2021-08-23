import 'package:get/get.dart';

/// The background manager for handling the height.
class BackgroundController extends GetxController {
  /// The factor of the height.
  final factor = (-1.0).obs;

  /// Set a new factor and notifiy the listeners.
  void updateFactor(double f) async {
    if (factor.value == -1.0) {
      factor.value = f;
    } else {
      factor.value = f;
      update();
    }
  }
}
