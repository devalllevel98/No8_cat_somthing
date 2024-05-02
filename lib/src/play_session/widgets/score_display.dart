import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../game_internals/game_service.dart';
import '../../style/cat_something_icons.dart';
import '../../style/palette.dart';

class ScoreDisplay extends StatelessWidget {
  const ScoreDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    return Consumer<GameService>(builder: (context, gameService, child) {
      return Align(
        alignment: Alignment.topRight,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          margin: const EdgeInsets.only(top: 20, right: 10),
          color: palette.backgroundMain.withOpacity(0.8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                CatSomethingIcons.mouse,
                color: Colors.white,
                size: 34,
              ),
              const SizedBox(
                width: 5,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  gameService.totalMouseCatched.toString(),
                  style: TextStyle(
                    fontFamily: "BitmapFont",
                    color: palette.trueWhite,
                    fontSize: 45,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
