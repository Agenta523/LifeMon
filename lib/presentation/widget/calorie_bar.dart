import 'package:flutter/material.dart';

class CalorieBar extends StatelessWidget {
  final double calorieRatio; // 0.0〜1.0
  final int calorieValue;

  const CalorieBar({
    Key? key,
    this.calorieRatio = 0.6,
    this.calorieValue = 1200,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double barWidth = MediaQuery.of(context).size.width;
    double filledWidth = barWidth * calorieRatio;

    return Stack(
      children: [
        // 背景バー（灰色）
        ClipPath(
          clipper: SlantedClipper(),
          child: Container(
            width: barWidth,
            height: 40,
            color: Colors.grey.shade300,
          ),
        ),
        // 緑のバー（摂取カロリー）
        ClipPath(
          clipper: SlantedClipper(),
          child: Container(width: filledWidth, height: 40, color: Colors.green),
        ),
        // カロリー表示テキスト
        Positioned(
          right: 0,
          top: 0,
          child: Text(
            '$calorieValue kcal',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}

// 平行四辺形に切り取るためのクリッパー
class SlantedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const double slant = 10.0; // 斜めの角度（ピクセル）
    return Path()
      ..moveTo(0, 0)
      ..lineTo(size.width - slant, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(slant, size.height)
      ..close();
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
