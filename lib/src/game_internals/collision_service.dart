import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import 'cat_positioning_service.dart';
import 'dogs_positioning_service.dart';
import 'game_service.dart';
import 'mouse_positioning_service.dart';

class CollisionService extends ChangeNotifier {
  late BuildContext _context;
  late Timer collisionControlTimer;
  bool _mouseCatched = false;

  void init(BuildContext contextParam) {
    _context = contextParam;
  }

  void onGameStarted() {
    collisionControlTimer = Timer.periodic(
        const Duration(
          milliseconds: 30,
        ),
        _controlCollisions);
  }

  void _controlCollisions(Timer timer) {
    DogsPositioningService dogsPositioningService =
        Provider.of<DogsPositioningService>(_context, listen: false);
    GameService gameService = Provider.of<GameService>(_context, listen: false);

    if (!gameService.isGameStarted) return;
    int numberOfDogs = gameService.numberOfDogs;

    Alignment currentCatAlignment =
        Provider.of<CatPositioningService>(_context, listen: false)
            .getCurrentAlignment();

    Alignment currentMouseAlignment =
        Provider.of<MousePositioningService>(_context, listen: false)
            .getCurrentAlignment();

    if (!_mouseCatched &&
        (currentCatAlignment.x - currentMouseAlignment.x).abs() < 0.06 &&
        (currentCatAlignment.y - currentMouseAlignment.y).abs() < 0.06) {
      _mouseCatched = true;
      _onMouseCatched();
    }

    List<Alignment> prevAlignmentOfDogs =
        dogsPositioningService.previousAlignmentsList;
    List<Alignment> nextAlignmentOfDogs =
        dogsPositioningService.nextAlignmentsList;

    for (int i = 0; i < numberOfDogs; i++) {
      Alignment currentDogAlignment = AlignmentTween(
              begin: prevAlignmentOfDogs[i], end: nextAlignmentOfDogs[i])
          .evaluate(dogsPositioningService.dogsAnimationController);

      if ((currentCatAlignment.x - currentDogAlignment.x).abs() < 0.06 &&
          (currentCatAlignment.y - currentDogAlignment.y).abs() < 0.06) {
        _endGame();
      }
    }
  }

  void _onMouseCatched() {
    Provider.of<GameService>(_context, listen: false).onMouseCatched();
    Provider.of<MousePositioningService>(_context, listen: false)
        .onMouseCatched();
    final audioController = _context.read<AudioController>();
    audioController.playSfx(SfxType.meow);
    _mouseCatched = false;
  }

  void _endGame() {
    collisionControlTimer.cancel();

    GameService gameService = Provider.of<GameService>(_context, listen: false);
    int totalMouseCatched = gameService.totalMouseCatched;

    gameService.onGameEnded();
    Provider.of<MousePositioningService>(_context, listen: false).onGameEnded();
    Provider.of<CatPositioningService>(_context, listen: false).onGameEnded();
    Provider.of<DogsPositioningService>(_context, listen: false).onGameEnded();

    final audioController = _context.read<AudioController>();
    audioController.playSfx(SfxType.dogBark);

    GoRouter.of(_context)
        .go('/play/result', extra: {'score': totalMouseCatched});
  }

  void onGameScreenDisposedBeforeEnd() {
    collisionControlTimer.cancel();
  }
}
