import 'package:sprinkle/Manager.dart';
import 'package:sprinkle/sprinkle.dart';

/// The background manager for handling the height.
class BackgroundManager extends Manager {
  /// The factor of the height.
  final factor = 0.0.reactive;

  // ignore: use_setters_to_change_properties
  /// Set a new factor and notifiy the listeners.
  void updateFactor(double f) async {
    factor.value = f;
  }

  @override
  void dispose() {
    factor.close();
  }
}
