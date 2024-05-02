import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../game_internals/game_service.dart';
import '../../game_internals/mouse_positioning_service.dart';

class Mouse extends StatefulWidget {
  const Mouse({super.key});

  @override
  State<Mouse> createState() => _MouseState();
}

class _MouseState extends State<Mouse> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  @override
  void initState() {
    int durationBetweenPointsForMouse =
        Provider.of<GameService>(context, listen: false)
            .durationBetweenPointsForMouse;

    _animationController = AnimationController(
        vsync: this,
        duration: Duration(seconds: durationBetweenPointsForMouse));

    Provider.of<MousePositioningService>(context, listen: false)
        .init(animationController: _animationController);

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MousePositioningService>(
        builder: (context, mousePositioningService, child) {
      return AlignTransition(
        alignment: AlignmentTween(
                begin: mousePositioningService.oldAlignment,
                end: mousePositioningService.nextAlignment)
            .animate(_animationController),
        child: Image.asset(
          "assets/images/mouse.png",
          width: 30,
          height: 30,
        ),
      );
    });
  }
}
