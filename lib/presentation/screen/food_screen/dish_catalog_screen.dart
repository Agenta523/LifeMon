import 'package:flutter/material.dart';
import 'package:life_mon/presentation/screen/food_screen/dish_catalog_data.dart';

class DishCatalogScreen extends StatefulWidget {
  final String dishCategory;
  final List<String> initialSelection;

  const DishCatalogScreen({
    Key? key,
    required this.dishCategory,
    required this.initialSelection,
  }) : super(key: key);

  @override
  State<DishCatalogScreen> createState() => _DishCatalogScreenState();
}

class _DishCatalogScreenState extends State<DishCatalogScreen> {
  late List<String> selectedDishes;
  late List<String> dishNames;

  @override
  void initState() {
    super.initState();
    selectedDishes = List.from(widget.initialSelection);
    dishNames = dishCatalogData[widget.dishCategory] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.dishCategory} 図鑑'),
        backgroundColor: const Color(0xFFF4B400),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: dishNames.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2列
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.9,
          ),
          itemBuilder: (context, index) {
            final dish = dishNames[index];
            final isSelected = selectedDishes.contains(dish);
            final imagePath = 'lib/presentation/images/$dish.png';

            return GestureDetector(
              onTap: () {
                setState(() {
                  isSelected
                      ? selectedDishes.remove(dish)
                      : selectedDishes.add(dish);
                });
              },
              child: Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            imagePath,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: const Icon(Icons.image_not_supported),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dish,
                        style: const TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  if (isSelected)
                    const Positioned(
                      top: 8,
                      right: 8,
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 24,
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(12),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF4B400),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: () {
              Navigator.pop(context, selectedDishes);
            },
            child: const Text(
              '完了',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
