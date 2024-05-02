// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

List<String> soundTypeToFilename(SfxType type) {
  switch (type) {
    case SfxType.buttonTap:
      return const [
        'meow1.mp3',
        'meow2.mp3',
        'meow3.mp3',
        'meow4.mp3',
        'meow5.mp3',
        'dogBark1.mp3',
        'dogBark2.mp3',
        'dogBark3.mp3',
      ];
    case SfxType.dogBark:
      return const [
        'dogBark1.mp3',
        'dogBark2.mp3',
        'dogBark3.mp3',
      ];
    case SfxType.meow:
      return const [
        'meow1.mp3',
        'meow2.mp3',
        'meow3.mp3',
        'meow4.mp3',
        'meow5.mp3',
      ];
  }
}

/// Allows control over loudness of different SFX types.
double soundTypeToVolume(SfxType type) {
  switch (type) {
    case SfxType.buttonTap:
    case SfxType.dogBark:
    case SfxType.meow:
      return 1.0;
  }
}

enum SfxType { buttonTap, dogBark, meow }
