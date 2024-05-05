import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../game_internals/cat_positioning_service.dart';
import '../game_internals/dogs_positioning_service.dart';
import '../game_internals/game_service.dart';
import '../game_internals/mouse_positioning_service.dart';
import '../games_services/games_services.dart';
import '../style/palette.dart';
import '../style/responsive_screen.dart';

class ResultScreen extends StatefulWidget {
  final int? score;
  const ResultScreen({super.key, this.score = 0});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  void initState() {
    super.initState();

    final gamesServicesController = context.read<GamesServicesController?>();
    if (gamesServicesController != null) {
      // Send score to leaderboard.
      gamesServicesController.submitLeaderboardScore(widget.score!);
    }
  }

  @override
  Widget build(BuildContext context) {


    final palette = context.watch<Palette>();
    return Scaffold(
      backgroundColor: palette.backgroundMain,
      body: ResponsiveScreen(
          squarishMainArea: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              
              SizedBox(
                height: 10,
              ),
              const Center(
                child: Text(
                  'OOPSIE!',
                  style: TextStyle(fontFamily: 'BitmapFont', fontSize: 50),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  'Score: ${widget.score}\n',
                  style:
                      const TextStyle(fontFamily: 'BitmapFont', fontSize: 20),
                ),
              ),
            ],
          ),
          rectangularMenuArea: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 200,
                height: 50,
                child: OutlinedButton(
                  onPressed: () {
                    Provider.of<CatPositioningService>(context, listen: false)
                        .onGameResettedAfterResult();
                    Provider.of<DogsPositioningService>(context, listen: false)
                        .onGameResettedAfterResult();
                    Provider.of<MousePositioningService>(context, listen: false)
                        .onGameResettedAfterResult();
                    Provider.of<GameService>(context, listen: false)
                        .onGameResettedAfterResult();
                    final audioController = context.read<AudioController>();
                    audioController.playSfx(SfxType.buttonTap);
                    GoRouter.of(context).go('/play');
                  },
                  child: const Text(
                    "NAH, THAT DOESN'T COUNT!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 200,
                height: 50,
                child: OutlinedButton(
                  onPressed: () {
                    GoRouter.of(context).go('/');
                  },
                  child: const Text(
                    "NO MORE FUN",
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              )
            ],
          )),
    );
  }
}
