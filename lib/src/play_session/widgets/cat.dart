import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../game_internals/cat_positioning_service.dart';
import '../../game_internals/game_service.dart';

class Cat extends StatefulWidget {
  const Cat({super.key});

  @override
  State<Cat> createState() => _CatState();
}

class _CatState extends State<Cat> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    int durationBetweenPointsForCat =
        Provider.of<GameService>(context, listen: false)
            .durationBetweenPointsForCat;

    _animationController = AnimationController(
        vsync: this, duration: Duration(seconds: durationBetweenPointsForCat));

    Provider.of<CatPositioningService>(context, listen: false)
        .init(_animationController);

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CatPositioningService>(
        builder: (context, catPositinioningService, child) {
      return AlignTransition(
        alignment: AlignmentTween(
                begin: catPositinioningService.oldAlignment,
                end: catPositinioningService.nextAlignment)
            .animate(_animationController),
        child: Image.asset(
          "assets/images/cat.png",
          width: 45,
          height: 45,
        ),
      );
    });
  }
}
