import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FoodButton extends StatelessWidget {
  final String imagePath;
  final String label;
  final VoidCallback onPressed;

  const FoodButton({
    super.key,
    required this.imagePath,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: Colors.white,
            child: SvgPicture.asset(imagePath, width: 32, height: 32),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: Color(0xFF9C6520))),
        ],
      ),
    );
  }
}
