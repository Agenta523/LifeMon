import 'package:flutter/material.dart';
import 'dart:math';

// CalorieBarウィジェットと関連クラスです。
// このファイルをインポートして、ご自身のアプリケーションでCalorieBarウィジェットをご利用ください。

/// カロリー摂取量を表示する平行四辺形のプログレスバーウィジェット
class CalorieBar extends StatelessWidget {
  /// 現在の摂取カロリー
  final int calorieValue;

  /// 目標カロリー
  final int calorieTarget;

  const CalorieBar({Key? key, this.calorieValue = 0, this.calorieTarget = 2000})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 利用可能な幅いっぱいにバーを表示
    double barWidth = MediaQuery.of(context).size.width - 40; // 左右のパディングを考慮

    // 目標カロリーに対する現在のカロリーの割合を計算
    // calorieTargetが0の場合のゼロ除算を防ぐ
    double calorieRatio =
        (calorieTarget > 0) ? (calorieValue / calorieTarget) : 0;

    // 割合が1.0（100%）を超えないようにする（バーが背景をはみ出さないように）
    double displayRatio = min(calorieRatio, 1.0);

    // 割合に基づいて塗りつぶされたバーの幅を計算
    double filledWidth = barWidth * displayRatio;

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
          child: Container(
            width: filledWidth,
            height: 40,
            // 目標を超えたら色を赤に変える
            color:
                calorieValue > calorieTarget
                    ? Colors.red.shade600
                    : Colors.green.shade500,
          ),
        ),
        // カロリー表示テキスト
        // Positioned.fillとAlignで、親ウィジェットの中央右に配置
        Positioned.fill(
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              // テキストがバーの端に寄らないようにパディングを追加
              padding: const EdgeInsets.only(right: 25.0),
              child: Text(
                // "現在の値 / 目標値 kcal" の形式で表示
                '$calorieValue / $calorieTarget kcal',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  // 文字に影をつけて読みやすくする
                  shadows: [
                    Shadow(
                      blurRadius: 2.0,
                      color: Colors.black54,
                      offset: Offset(1.0, 1.0),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// 平行四辺形に切り取るためのクリッパー
class SlantedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // 斜めの角度を調整
    const double slant = 20.0;
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
