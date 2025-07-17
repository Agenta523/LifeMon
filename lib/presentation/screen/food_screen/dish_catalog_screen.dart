import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    selectedDishes = List.from(widget.initialSelection);
  }

  @override
  Widget build(BuildContext context) {
    final dishes = List.generate(
      20,
      (index) => '${widget.dishCategory}${index + 1}',
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.dishCategory} 図鑑'),
        backgroundColor: const Color(0xFFF4B400),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // ← 横に2つ並べる
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 3 / 2,
              ),
              itemCount: dishes.length,
              itemBuilder: (context, index) {
                final dish = dishes[index];
                final isSelected = selectedDishes.contains(dish);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedDishes.remove(dish);
                      } else {
                        selectedDishes.add(dish);
                      }
                    });
                  },
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.orange[100],
                          borderRadius: BorderRadius.circular(16),
                          image: DecorationImage(
                            image: AssetImage(
                              'assets/images/${dish}.png',
                            ), // 必要に応じて画像名調整
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Icon(
                          isSelected
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: isSelected ? Colors.green : Colors.white,
                          size: 28,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                            ),
                          ),
                          child: Text(
                            dish,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SafeArea(
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
        ],
      ),
    );
  }
}
