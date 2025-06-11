import 'package:flutter/material.dart';

class DishCatalogScreen extends StatelessWidget {
  final String dishCategory;

  const DishCatalogScreen({Key? key, required this.dishCategory})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dishes = List.generate(4, (index) => '$dishCategory${index + 1}');

    return Scaffold(
      appBar: AppBar(
        title: Text('$dishCategory 図鑑'),
        backgroundColor: const Color(0xFFF4B400),
      ),
      body: ListView.builder(
        itemCount: dishes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('$dishCategory${index + 1}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder:
                      (_) => DishRegisterScreen(
                        dishName: dishes[index],
                        category: dishCategory,
                      ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class DishRegisterScreen extends StatelessWidget {
  final String dishName;
  final String category;

  const DishRegisterScreen({
    Key? key,
    required this.dishName,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$category 登録: $dishName'),
        backgroundColor: const Color(0xFFF4B400),
      ),
      body: Center(
        child: Text(
          '$dishName の詳細をここで登録してください',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
