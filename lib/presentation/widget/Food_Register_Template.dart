import 'package:flutter/material.dart';

class FoodRegisterTemplate extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;

  const FoodRegisterTemplate({
    Key? key,
    required this.title,
    required this.message,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFFF4B400),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 100, color: const Color(0xFFF4B400)),
            const SizedBox(height: 20),
            Text(
              message,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // 登録処理や戻る処理を書く
                Navigator.of(context).pop();
              },
              child: const Text('登録完了'),
            ),
          ],
        ),
      ),
    );
  }
}
