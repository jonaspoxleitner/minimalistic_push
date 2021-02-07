import 'dart:ui';

import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';

class Peaks {
  Peaks({
    @required this.list,
  });

  final List<double> list;

  Peaks lerp(Peaks a, Peaks b, double t) {
    return Peaks(list: _lerpList(a.list, b.list, t));
  }

  // TODO: give credit to fl_chart
  List<double> _lerpList(List<double> a, List<double> b, double t) {
    if (a != null && b != null && a.length == b.length) {
      return List.generate(a.length, (i) {
        return lerpDouble(a[i], b[i], t);
      });
    } else if (a != null && b != null) {
      return List.generate(b.length, (i) {
        return lerpDouble(i >= a.length ? b[i] : a[i], b[i], t);
      });
    } else {
      return b;
    }
  }
}

// TODO: give credit to fl_chart
class PeaksTween extends Tween<Peaks> {
  PeaksTween({Peaks begin, Peaks end}) : super(begin: begin, end: end);

  @override
  Peaks lerp(double t) => begin.lerp(begin, end, t);
}
