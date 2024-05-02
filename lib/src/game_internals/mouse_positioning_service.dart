import 'package:flutter/cupertino.dart';

import '../play_session/helpers/positioning_helpers.dart';

class MousePositioningService extends ChangeNotifier {
  late AnimationController _animationController;
  late Alignment oldAlignment;
  late Alignment nextAlignment;

  Alignment getCurrentAlignment() {
    Alignment currentAlignment =
        AlignmentTween(begin: oldAlignment, end: nextAlignment)
            .evaluate(_animationController);

    return currentAlignment;
  }

  void init({required AnimationController animationController}) {
    _animationController = animationController;

    Alignment alignment = PositioningHelpers.generateRandomAlignment();
    oldAlignment = alignment;
    nextAlignment = alignment;
  }

  void onGameEnded() {
    _animationController.reset();
    _animationController.stop();
    notifyListeners();
  }

  void onGameResettedAfterResult() {
    oldAlignment = PositioningHelpers.generateRandomAlignment();
    nextAlignment = oldAlignment;
    _animationController.reset();
    notifyListeners();
  }

  void onMouseCatched() {
    oldAlignment = PositioningHelpers.generateRandomAlignment();
    nextAlignment = oldAlignment;
    _animationController.reset();
    notifyListeners();
  }

  void resetTarget() {
    oldAlignment = nextAlignment;
    nextAlignment = PositioningHelpers.generateRandomAlignment();
    _animationController.reset();
    _animationController.forward();
    notifyListeners();
  }
}
