import 'package:flutter/material.dart';
import 'dart:math';

class BodyIcons extends StatefulWidget {
  final List<IconData> icons;
  final List<String> labels;
  final int selectedIndex;
  final Function(int) onSelected;
  final List<Color> colors_list;
  final int icons_length;
  final List<int> eat_values;
  final List<int> eat_values_base;

  const BodyIcons({
    super.key,
    required this.icons,
    required this.labels,
    required this.selectedIndex,
    required this.onSelected,
    required this.colors_list,
    required this.icons_length,
    required this.eat_values,
    required this.eat_values_base,
  });

  @override
  State<BodyIcons> createState() => _BodyIcons();
}

class _BodyIcons extends State<BodyIcons> {
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
          for (int i = 0; i < 3;) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: GestureDetector(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  width: MediaQuery.of(context).size.width * 0.25,
                  decoration: BoxDecoration(
                    color: widget.colors_list[index],
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        widget.icons[index],
                        color: Colors.white,
                        size:
                            [
                              MediaQuery.of(context).size.width,
                              MediaQuery.of(context).size.height,
                            ].reduce(min) *
                            0.08,
                      ),
                      Text(
                        widget.labels[index],
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 6), // 余白を追加
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${widget.eat_values[index]} / ${widget.eat_values_base[index]} g',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
