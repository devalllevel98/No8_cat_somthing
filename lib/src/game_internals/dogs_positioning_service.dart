import 'package:flutter/cupertino.dart';

import '../play_session/helpers/positioning_helpers.dart';

class DogsPositioningService extends ChangeNotifier {
  late List<Alignment> previousAlignmentsList;
  late List<Alignment> nextAlignmentsList;
  late int _numberOfDogs;
  late AnimationController dogsAnimationController;

  void init({
    required AnimationController animationController,
    required int numberOfDogs,
  }) {
    _numberOfDogs = numberOfDogs;
    dogsAnimationController = animationController;
    previousAlignmentsList = [
      for (int i = 0; i < _numberOfDogs; i++)
        PositioningHelpers.generateRandomAlignment()
    ];

    nextAlignmentsList = [...previousAlignmentsList];
  }

  void resetDogsTargets() {
    previousAlignmentsList = nextAlignmentsList;
    nextAlignmentsList = [
      for (int i = 0; i < _numberOfDogs; i++)
        PositioningHelpers.generateRandomAlignment()
    ];
    dogsAnimationController.reset();
    dogsAnimationController.forward();

    notifyListeners();
  }

  void onGameResettedAfterResult() {
    previousAlignmentsList = [
      for (int i = 0; i < _numberOfDogs; i++)
        PositioningHelpers.generateRandomAlignment()
    ];

    nextAlignmentsList = [...previousAlignmentsList];
    dogsAnimationController.reset();
    notifyListeners();
  }

  void onGameEnded() {
    dogsAnimationController.reset();
    dogsAnimationController.stop();
  }
}
