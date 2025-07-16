import 'package:flutter/material.dart';

class UserProfileHeader extends StatelessWidget {
  final VoidCallback onTap;

  const UserProfileHeader({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 40,
      left: 20,
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: const [
            CircleAvatar(backgroundColor: Colors.grey, radius: 24),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "ユーザー名",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text("今日も元気に活動中", style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
