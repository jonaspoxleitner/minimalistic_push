import 'dart:ui' as ui;

import 'package:flutter/animation.dart';

/// The object for a list of peaks.
class Peaks {
  /// The constructor, which requires a list.
  Peaks({required this.list});

  /// The list with the 'height' of the peaks as double.
  final List<double> list;

  /// Lerps the list.
  Peaks lerp(Peaks a, Peaks b, double t) => Peaks(list: _lerpList(a.list, b.list, t));

  // this function for lerping a list of doubles was copied from
  // https://github.com/imaNNeoFighT/fl_chart
  List<double> _lerpList(List<double> a, List<double> b, double t) {
    if (a.length == b.length) {
      return List.generate(a.length, (i) => ui.lerpDouble(a[i], b[i], t)!);
    } else {
      return List.generate(b.length, (i) => ui.lerpDouble(i >= a.length ? b[i] : a[i], b[i], t)!);
    }
  }
}

/// A Tween of the Peaks object.
// this class was kinda copied from https://github.com/imaNNeoFighT/fl_chart
class PeaksTween extends Tween<Peaks> {
  /// The constructor, which requires a beginning and end.
  PeaksTween({Peaks? begin, Peaks? end}) : super(begin: begin, end: end);

  @override
  Peaks lerp(double t) => begin!.lerp(begin!, end!, t);
}
