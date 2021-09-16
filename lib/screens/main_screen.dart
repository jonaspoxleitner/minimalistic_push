import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minimalistic_push/control/background_controller.dart';
import 'package:minimalistic_push/control/preferences_controller.dart';
import 'package:minimalistic_push/control/session_controller.dart';
import 'package:minimalistic_push/localizations.dart';
import 'package:minimalistic_push/models/session.dart';
import 'package:minimalistic_push/screens/named_overlay_route.dart';
import 'package:minimalistic_push/styles/styles.dart';
import 'package:minimalistic_push/widgets/navigation_bar.dart';
import 'package:proximity_sensor/proximity_sensor.dart';

/// The main screen of the application.
class MainScreen extends StatefulWidget {
  /// The constructor for the main screen.
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final ValueNotifier<double> animationNotifier = ValueNotifier(0.0);
  final ValueNotifier<bool> trainingModeNotifier = ValueNotifier(false);

  @override
  void initState() {
    trainingModeNotifier.addListener(() => super.setState(() {}));

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animationController.animateTo(
      1.0,
      curve: Curves.easeInOutQuart,
    );

    // this listener gets executed, when this widget comes into focus again
    animationNotifier.addListener(() {
      _animationController.animateTo(
        1.0 - animationNotifier.value,
        curve: Curves.easeInOutQuart,
      );
    });

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var backgroundController = Get.find<BackgroundController>();

    if (backgroundController.factor.value <= 0.6) {
      backgroundController.updateFactor(0.6);
    }

    if (!trainingModeNotifier.value) {
      return AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) => Opacity(
          opacity: _animationController.value,
          child: child,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) => Transform.translate(
                offset: Offset(0.0, -20 + _animationController.value * 20),
                child: child,
              ),
              child: NavigationBar(
                text: MyLocalizations.of(context).values!['training']['title'],
                leftOption: NavigationOption(
                  icon: Icons.list,
                  onPressed: () => Navigator.push(
                    context,
                    NamedOverlayRoute(
                      overlayName: 'sessions',
                      animationNotifier: animationNotifier,
                      context: context,
                    ),
                  ),
                ),
                rightOption: NavigationOption(
                  icon: Icons.settings,
                  onPressed: () => Navigator.push(
                    context,
                    NamedOverlayRoute(
                      overlayName: 'settings',
                      animationNotifier: animationNotifier,
                      context: context,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        trainingModeNotifier.value = true;
                      },
                      child: AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) => Transform.translate(
                          offset: Offset(0.0, 20 - _animationController.value * 20),
                          child: child,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).size.height / 10,
                              ),
                              child: Text(
                                MyLocalizations.of(context).values!['training']['start'],
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 64.0,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GetBuilder<PreferencesController>(
                                builder: (preferencesController) {
                                  var hardcore = preferencesController.hardcore.isTrue;
                                  return Text(
                                    MyLocalizations.of(context).values!['training']['hardcore'][hardcore],
                                    style: TextStyles.body,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return _TrainingWidget(
        trainingMode: trainingModeNotifier,
        hardcore: Get.find<PreferencesController>().hardcore.value,
      );
    }
  }
}

class _TrainingWidget extends StatefulWidget {
  final ValueNotifier<bool> trainingMode;
  final bool hardcore;

  const _TrainingWidget({
    Key? key,
    required this.trainingMode,
    required this.hardcore,
  }) : super(key: key);

  @override
  _TrainingWidgetState createState() => _TrainingWidgetState();
}

class _TrainingWidgetState extends State<_TrainingWidget> {
  int counter = 1;

  var _proximity = false;
  late StreamSubscription<dynamic> _streamSubscription;

  void _buttonTap() async => super.setState(() => counter++);

  @override
  void initState() {
    if (!widget.hardcore) {
      _streamSubscription = ProximitySensor.events.listen((event) {
        var p = event > 0;
        if (_proximity && p) _buttonTap();
        _proximity = !p;
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    if (!widget.hardcore) _streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                padding: const EdgeInsets.all(16.0),
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onPressed: () => _showCancelDialog(counter),
              ),
              IconButton(
                padding: const EdgeInsets.all(16.0),
                icon: const Icon(
                  Icons.done_all,
                  color: Colors.white,
                ),
                onPressed: () {
                  Get.find<SessionController>().insertSession(Session(count: counter));
                  widget.trainingMode.value = false;
                },
              ),
            ],
          ),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _buttonTap,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    counter.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 64.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );

  Future<void> _showCancelDialog(int count) async => showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(MyLocalizations.of(context).values!['training']['alert']['title']),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  MyLocalizations.of(context).values!['training']['alert']['contents'][0] +
                      count.toString() +
                      MyLocalizations.of(context).values!['training']['alert']['contents'][1],
                ),
                Text(MyLocalizations.of(context).values!['training']['alert']['contents'][2]),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(primary: Theme.of(context).primaryColor),
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                MyLocalizations.of(context).values!['training']['alert']['continue'],
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(primary: Theme.of(context).primaryColor),
              onPressed: () {
                widget.trainingMode.value = false;
                Navigator.of(context).pop();
              },
              child: Text(
                MyLocalizations.of(context).values!['training']['alert']['end'],
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        ),
      );
}
