import 'package:flutter/material.dart';

class DishCatalogScreen extends StatelessWidget {
  const DishCatalogScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dishes = ['副菜1', '副菜2', '副菜3', '副菜4'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('図鑑'),
        backgroundColor: const Color(0xFFF4B400),
      ),
      body: ListView.builder(
        itemCount: dishes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(dishes[index]),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // ここで選択した料理の登録画面に遷移
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder:
                      (_) => SideDishRegisterScreen(dishName: dishes[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class SideDishRegisterScreen extends StatelessWidget {
  final String dishName;

  const SideDishRegisterScreen({Key? key, required this.dishName})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('副菜登録: $dishName'),
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
