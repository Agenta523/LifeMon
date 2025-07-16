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
      20, // ← デモ用に多めに
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
            child: ListView.builder(
              itemCount: dishes.length,
              itemBuilder: (context, index) {
                final dish = dishes[index];
                final isSelected = selectedDishes.contains(dish);
                return ListTile(
                  title: Text(dish),
                  trailing:
                      isSelected
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : const Icon(Icons.circle_outlined),
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedDishes.remove(dish);
                      } else {
                        selectedDishes.add(dish);
                      }
                    });
                  },
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
