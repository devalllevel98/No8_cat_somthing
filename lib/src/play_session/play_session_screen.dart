// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:game_template/src/play_session/widgets/mouse.dart';
import 'package:game_template/src/play_session/widgets/score_display.dart';
import 'package:logging/logging.dart' hide Level;
import 'package:provider/provider.dart';
import '../ads/ads_controller.dart';
import '../game_internals/cat_positioning_service.dart';
import '../game_internals/collision_service.dart';
import '../game_internals/dogs_positioning_service.dart';
import '../game_internals/game_service.dart';
import '../in_app_purchase/in_app_purchase.dart';
import 'widgets/cat.dart';
import 'widgets/dog.dart';

class PlaySessionScreen extends StatefulWidget {
  const PlaySessionScreen({super.key});

  @override
  State<PlaySessionScreen> createState() => _PlaySessionScreenState();
}

class _PlaySessionScreenState extends State<PlaySessionScreen>
    with SingleTickerProviderStateMixin {
  static final _log = Logger('PlaySessionScreen');
  double _screenWidth = 0;
  double _screenHeight = 0;
  late AnimationController _othersAnimationContoller;
  late int _numberOfDogs;
  Random random = Random();

  late GameService _gameService;
  late CollisionService _collisionService;

  @override
  void initState() {
    super.initState();
    _gameService = Provider.of<GameService>(context, listen: false);
    _collisionService = Provider.of<CollisionService>(context, listen: false);
    // Preload ad for the win screen.
    final adsRemoved =
        context.read<InAppPurchaseController?>()?.adRemoval.active ?? false;
    if (!adsRemoved) {
      final adsController = context.read<AdsController?>();
      adsController?.preloadAd();
    }
    _numberOfDogs = _gameService.numberOfDogs;

    int durationBetweenPointsForDogs =
        _gameService.durationBetweenPointsForDogs;

    _othersAnimationContoller = AnimationController(
        vsync: this, duration: Duration(seconds: durationBetweenPointsForDogs));

    Provider.of<DogsPositioningService>(context, listen: false).init(
      animationController: _othersAnimationContoller,
      numberOfDogs: _numberOfDogs,
    );

    _collisionService.init(context);
    _gameService.init(context);
  }

  @override
  void dispose() {
    if (_gameService.isGameStarted) {
      _gameService.onGameScreenDisposedBeforeEnd();
      _collisionService.onGameScreenDisposedBeforeEnd();
    }
    _othersAnimationContoller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: GestureDetector(
        onTapDown: _onTapDown,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              "assets/images/background.png",
              fit: BoxFit.cover,
            ),
            const Mouse(),
            const Cat(),
            for (int i = 0; i < _numberOfDogs; i++)
              Dog(
                dogIndex: i,
              ),
            ScoreDisplay(),
          ],
        ),
      ),
    );
  }

  void _onTapDown(TapDownDetails details) {
    double targetAlignmentX =
        (details.globalPosition.dx - (_screenWidth / 2)) / (_screenWidth / 2);
    double targetAlignmentY =
        (details.globalPosition.dy - (_screenHeight / 2)) / (_screenHeight / 2);

    Provider.of<CatPositioningService>(context, listen: false)
        .setTargetAlignment(Alignment(targetAlignmentX, targetAlignmentY));

    Provider.of<GameService>(context, listen: false).onGameStarted();
  }
}
