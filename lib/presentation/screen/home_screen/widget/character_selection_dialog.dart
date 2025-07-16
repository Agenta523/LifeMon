import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:life_mon/presentation/screen/home_screen/widget/character_info.dart';

class CharacterSelectionDialog extends StatefulWidget {
  final List<CharacterInfo> characters;
  final int initialIndex;
  final Function(int) onCharacterSelected;
  final VoidCallback onSwitchToGrid;

  const CharacterSelectionDialog({
    Key? key,
    required this.characters,
    required this.initialIndex,
    required this.onCharacterSelected,
    required this.onSwitchToGrid,
  }) : super(key: key);

  @override
  State<CharacterSelectionDialog> createState() =>
      _CharacterSelectionDialogState();
}

class _CharacterSelectionDialogState extends State<CharacterSelectionDialog> {
  late int _tempIndex;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _tempIndex = widget.initialIndex;
    _pageController = PageController(
      initialPage: _tempIndex,
      viewportFraction: 0.8,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 500,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 8),
                Text(
                  widget.characters[_tempIndex].name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.characters[_tempIndex].description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: widget.characters.length,
                    onPageChanged: (index) {
                      setState(() => _tempIndex = index);
                    },
                    itemBuilder: (context, index) {
                      return Transform.scale(
                        scale: index == _tempIndex ? 1.0 : 0.85,
                        child: RiveAnimation.asset(
                          widget.characters[index].riveFile,
                          fit: BoxFit.contain,
                        ),
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    widget.onCharacterSelected(_tempIndex);
                    Navigator.pop(context);
                  },
                  child: const Text("呼ぶ"),
                ),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.grid_view_rounded),
                onPressed: widget.onSwitchToGrid,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
