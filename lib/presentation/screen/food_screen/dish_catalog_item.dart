import 'package:flutter/material.dart';
import 'dish_catalog_data.dart';

class DishCatalogItem extends StatelessWidget {
  final DishData dish;
  final VoidCallback onTap;

  const DishCatalogItem({super.key, required this.dish, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Image.asset(dish.imagePath, width: 80, height: 80, fit: BoxFit.cover),
          const SizedBox(height: 8),
          Text(dish.name, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
