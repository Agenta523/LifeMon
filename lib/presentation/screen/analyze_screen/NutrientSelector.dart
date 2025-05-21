import 'package:flutter/material.dart';

class NutrientSelector extends StatefulWidget {
  final List<IconData> icons;
  final List<String> labels;
  final int selectedIndex;
  final Function(int) onSelected;
  final Color buttonColor;

  const NutrientSelector({
    super.key,
    required this.icons,
    required this.labels,
    required this.selectedIndex,
    required this.onSelected,
    required this.buttonColor,
  });

  @override
  State<NutrientSelector> createState() => _NutrientSelectorState();
}

class _NutrientSelectorState extends State<NutrientSelector> {
  final ScrollController _scrollController = ScrollController();

  void _centerItem(int index) {
    // 各ボタンのサイズ + padding
    const double itemWidth = 150 + 40; // 150 + padding (20左右)
    // 中央に表示されるためのオフセット計算
    final double screenWidth = MediaQuery.of(context).size.width;
    final double offset = (itemWidth * index + itemWidth / 2) - screenWidth / 2;

    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  @override
  void initState() {
    super.initState();
    // 初期表示で中央に寄せる
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _centerItem(widget.selectedIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: widget.labels.length,
        itemBuilder: (context, index) {
          final isSelected = index == widget.selectedIndex;
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: GestureDetector(
              onTap: () {
                widget.onSelected(index);
                _centerItem(index);
              },
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  color: isSelected ? widget.buttonColor : widget.buttonColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    Icon(
                      widget.icons[index],
                      color: isSelected ? Colors.white : Colors.grey[800],
                      size: 40,
                    ),
                    Text(
                      widget.labels[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[800],
                      ),
                    )
                  ] 
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
