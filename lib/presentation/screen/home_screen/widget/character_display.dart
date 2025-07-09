// lib/presentation/screens/home/widgets/character_display.dart

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class CharacterDisplay extends StatelessWidget {
  final Artboard artboard;
  final double x;
  final double y;
  final double size;
  final bool isFacingLeft;

  const CharacterDisplay({
    Key? key,
    required this.artboard,
    required this.x,
    required this.y,
    required this.size,
    required this.isFacingLeft,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: x,
      top: y,
      child: SizedBox(
        width: size,
        height: size,
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()..scale(isFacingLeft ? -1.0 : 1.0, 1.0),
          child: Rive(artboard: artboard),
        ),
      ),
    );
  }
}
