// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

/// A palette of colors to be used in the game.
///
/// The reason we're not going with something like Material Design's
/// `Theme` is simply that this is simpler to work with and yet gives
/// us everything we need for a game.
///
/// Games generally have more radical color palettes than apps. For example,
/// every level of a game can have radically different colors.
/// At the same time, games rarely support dark mode.
///
/// Colors taken from this fun palette:
/// https://lospec.com/palette-list/crayola84
///
/// Colors here are implemented as getters so that hot reloading works.
/// In practice, we could just as easily implement the colors
/// as `static const`. But this way the palette is more malleable:
/// we could allow players to customize colors, for example,
/// or even get the colors from the network.
class Palette {
  Color get pen => const Color(0xffBAA89B);
  Color get darkPen => const Color(0xFF524439);
  Color get redPen => const Color(0xFFd10841);
  Color get inkFullOpacity => const Color(0xff352b42);
  Color get ink => const Color(0xffBAA89B);
  Color get backgroundMain => Color(0xFF005C1B);
  Color get backgroundLevelSelection => const Color(0xffa2dcc7);
  Color get backgroundPlaySession => Color.fromARGB(255, 69, 68, 66);
  Color get background4 => const Color(0xffffd7ff);
  Color get backgroundSettings => const Color(0xff524439);
  Color get trueWhite => const Color(0xffffffff);
  Color get outlinedButtonColor => Color(0xffBAA89B);
  Color get pressedOutlinedButtonColor => Color(0xffB76600);
  Color get backgroundSettingsDialog => Color(0xffBAA89B);

  List<Color> get colors => [
        Color(0xffB76600),
        Color(0xff524439),
        Color(0xff524439),
        Color(0xff009049),
        Color(0xff005C1B),
      ];
}
