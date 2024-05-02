import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'collision_service.dart';
import 'dogs_positioning_service.dart';
import 'mouse_positioning_service.dart';

class GameService extends ChangeNotifier {
  int numberOfDogs = 3;
  int durationBetweenPointsForCat = 2;
  int durationBetweenPointsForMouse = 2;
  int durationBetweenPointsForDogs = 2;
  bool isGameStarted = false;
  late BuildContext _context;
  late Timer autonumousItemsTimer;

  int totalMouseCatched = 0;

  void init(BuildContext context) {
    _context = context;
    isGameStarted = false;
    totalMouseCatched = 0;
  }

  void _onAutonomousTimerTick() {
    if (!isGameStarted) {
      return;
    }

    Provider.of<DogsPositioningService>(_context, listen: false)
        .resetDogsTargets();

    Provider.of<MousePositioningService>(_context, listen: false).resetTarget();
  }

  void onGameStarted() {
    if (!isGameStarted) {
      isGameStarted = true;
      Provider.of<CollisionService>(_context, listen: false).onGameStarted();
      autonumousItemsTimer = Timer.periodic(
          Duration(seconds: durationBetweenPointsForDogs), (timer) {
        _onAutonomousTimerTick();
      });
    }
  }

  void onGameResettedAfterResult() {
    totalMouseCatched = 0;
    notifyListeners();
  }

  void onGameEnded() {
    isGameStarted = false;
    autonumousItemsTimer.cancel();
  }

  void onMouseCatched() {
    totalMouseCatched++;
    notifyListeners();
  }

  void onGameScreenDisposedBeforeEnd() {
    autonumousItemsTimer.cancel();
  }
}
