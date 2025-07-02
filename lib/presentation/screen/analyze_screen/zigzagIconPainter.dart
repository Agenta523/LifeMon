import 'package:flutter/material.dart';

class ZigzagIconPainter extends CustomPainter {
  final int rows;
  final int columns;
  final double iconSize;
  final double spacing;
  final Color color;
  final IconData  icons;

  ZigzagIconPainter({
    required this.rows,
    required this.columns,
    required this.iconSize,
    required this.spacing,
    required this.color,
    required this.icons,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final icon = icons;
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    final builder = (IconData iconData) => TextSpan(
      text: String.fromCharCode(iconData.codePoint),
      style: TextStyle(
        fontSize: iconSize,
        fontFamily: iconData.fontFamily,
        color: color,
      ),
    );

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < columns; col++) {
        double dx = col * spacing;
        double dy = row * spacing;

        // 奇数行をずらす
        if (row % 2 == 1) {
          dx += spacing / 2;
        }

        final offset = Offset(dx, dy);
        textPainter.text = builder(icon);
        textPainter.layout();
        textPainter.paint(canvas, offset);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
