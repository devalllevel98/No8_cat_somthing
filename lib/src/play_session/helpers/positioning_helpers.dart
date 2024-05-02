import 'dart:math';

import 'package:flutter/material.dart';

class PositioningHelpers {
  static double _generateRandomCoordinateAxisValue() {
    Random rand = Random();
    return (rand.nextBool() ? -1 : 1) * rand.nextDouble();
  }

  static Alignment generateRandomAlignment() {
    return Alignment(_generateRandomCoordinateAxisValue(),
        _generateRandomCoordinateAxisValue());
  }
}
