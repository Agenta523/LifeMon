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
      backgroundColor: const Color(0xFFA8DAB5),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF2D9),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4B400),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(message, style: const TextStyle(fontSize: 14)),
                  ),
                  Positioned(
                    top: -10,
                    right: -10,
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.white,
                      child: Icon(
                        icon,
                        size: 30,
                        color: const Color(0xFF9C6520),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    '+',
                    style: TextStyle(
                      fontSize: 30,
                      color: Color(0xFF9C6520),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF4B400),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                  child: Text('戻る', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
