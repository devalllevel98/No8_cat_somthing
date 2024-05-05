// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:game_template/src/style/cat_something_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../games_services/games_services.dart';
import '../settings/settings.dart';
import '../style/palette.dart';
import '../style/responsive_screen.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();

  static const _gap = SizedBox(height: 10);
}

class _MainMenuScreenState extends State<MainMenuScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController =
      AnimationController(duration: const Duration(seconds: 1), vsync: this)
        ..repeat(reverse: true);
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(0, -0.15),
  ).animate(CurvedAnimation(
    parent: _animationController,
    curve: Curves.easeInOutBack,
  ));

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final gamesServicesController = context.watch<GamesServicesController?>();
    final settingsController = context.watch<SettingsController>();
    final audioController = context.watch<AudioController>();

    return Scaffold(
      backgroundColor: palette.backgroundMain,
      body: ResponsiveScreen(
        mainAreaProminence: 0.45,
        squarishMainArea: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SlideTransition(
                position: _offsetAnimation,
                child: Image.asset(
                  "assets/images/cat.png",
                  width: 200,
                  height: 200,
                ),
              ),
              FittedBox(
                alignment: Alignment.center,
                fit: BoxFit.scaleDown,
                child: const Text(
                  'CAT SOMETHING!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'BitmapFont',
                    fontSize: 50,
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
        rectangularMenuArea: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 240,
              height: 50,
              child: OutlinedButton(
                onPressed: () {
                  audioController.playSfx(SfxType.buttonTap);
                  GoRouter.of(context).go('/play');
                },
                child: const Text(
                  "PLAY",
                ),
              ),
            ),
            MainMenuScreen._gap,
            if (gamesServicesController != null) ...[
              _hideUntilReady(
                ready: gamesServicesController.signedIn,
                child: SizedBox(
                  width: 240,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () => gamesServicesController.showLeaderboard(),
                    child: const Text('Leaderboard'),
                  ),
                ),
              ),
              MainMenuScreen._gap,
            ],
            SizedBox(
              width: 240,
              height: 50,
              child: OutlinedButton(
                onPressed: () => GoRouter.of(context).go('/settings'),
                child: const Text('Settings'),
              ),
            ),
            MainMenuScreen._gap,
            Padding(
              padding: const EdgeInsets.only(top: 32),
              child: ValueListenableBuilder<bool>(
                valueListenable: settingsController.muted,
                builder: (context, muted, child) {
                  return IconButton(
                    onPressed: () => settingsController.toggleMuted(),
                    icon: Icon(
                      muted ? CatSomethingIcons.mute : CatSomethingIcons.unmute,
                      size: 35,
                      color: palette.ink,
                    ),
                  );
                },
              ),
            ),
            MainMenuScreen._gap,
            // const Text('developed by SerhanK'),
            MainMenuScreen._gap,
          ],
        ),
      ),
    );
  }

  /// Prevents the game from showing game-services-related menu items
  /// until we're sure the player is signed in.
  ///
  /// This normally happens immediately after game start, so players will not
  /// see any flash. The exception is folks who decline to use Game Center
  /// or Google Play Game Services, or who haven't yet set it up.
  Widget _hideUntilReady({required Widget child, required Future<bool> ready}) {
    return FutureBuilder<bool>(
      future: ready,
      builder: (context, snapshot) {
        // Use Visibility here so that we have the space for the buttons
        // ready.
        return Visibility(
          visible: snapshot.data ?? false,
          maintainState: true,
          maintainSize: true,
          maintainAnimation: true,
          child: child,
        );
      },
    );
  }
}
