import 'package:flutter/material.dart';
import 'package:life_mon/presentation/screen/home_screen/widget/character_info.dart';

class CharacterGridDialog extends StatelessWidget {
  final List<CharacterInfo> characters;
  final Function(int) onCharacterSelected;
  final VoidCallback onGoBack;

  const CharacterGridDialog({
    Key? key,
    required this.characters,
    required this.onCharacterSelected,
    required this.onGoBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Stack(
        alignment: Alignment.center,
        children: [
          // Back button to reopen the PageView dialog
          Positioned(
            left: -12,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onGoBack,
            ),
          ),
          const Text('キャラクター一覧'),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: GridView.builder(
          shrinkWrap: true,
          itemCount: characters.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                onCharacterSelected(index);
                Navigator.pop(context);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(characters[index].iconImage),
                    radius: 30,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    characters[index].name,
                    style: const TextStyle(fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
