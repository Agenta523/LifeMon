import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import './NutrientSelector.dart';
import './FLChartData.dart';
import './zigzagIconPainter.dart';
import 'package:life_mon/data/FoodLogStorage.dart';

final DateValueStorage _storage = DateValueStorage();

class AnalyzeScreen extends StatefulWidget {
  const AnalyzeScreen({super.key});

  @override
  State<AnalyzeScreen> createState() => _AnalyzeScreenState();
}

class _AnalyzeScreenState extends State<AnalyzeScreen> {
  int selectedIndex = 0;
  List<int> calorie = List.filled(7, 0); // 7つの0で初期化
  List<int> carbo = List.filled(7, 0);
  List<int> fat = List.filled(7, 0);
  List<int> protein = List.filled(7, 0);

  @override
  void initState(){
    super.initState();
    _loadNutrientData();
  }
  
  /// 週次栄養素データを非同期で読み込み、Stateを更新する。
  Future<void> _loadNutrientData() async {
    await _storage.init(); // ストレージを初期化（保存されたデータをロード）。

    // 週ごとのPFCデータリストを取得。
    List<List<int>> pfcListsFromStorage = _storage.getWeeklyPFCLists();

    setState(() {
      // 取得したPFCデータを各リストに格納。
      protein = pfcListsFromStorage[0];
      fat = pfcListsFromStorage[1];
      carbo = pfcListsFromStorage[2];
    });
  }

  Color getLineColor(int index) {
    switch (index) {
      case 0:  // calorie
        return const Color.fromARGB(255, 253, 163, 120);
      case 1:  // protein
        return const Color.fromARGB(255, 255, 123, 134);
      case 2:  // fat
        return const Color.fromARGB(255, 255, 187, 0);
      case 3:  // carbo
        return const Color.fromARGB(255, 123, 134, 255); 
      default:
        return Colors.blue;
    }
  }

  List<FlSpot> getLineData(int index) {
    switch (index) {
      case 0:
        return List.generate(calorie.length, (i) => FlSpot(i.toDouble(), calorie[i].toDouble()));
      case 1:
        return List.generate(protein.length, (i) => FlSpot(i.toDouble(), protein[i].toDouble()));
      case 2:
        return List.generate(fat.length, (i) => FlSpot(i.toDouble(), fat[i].toDouble()));
      case 3:
        return List.generate(carbo.length, (i) => FlSpot(i.toDouble(), carbo[i].toDouble()));
      default:
        return [];
    }
  }

  String getUnit(int index) {
    if(index == 0){
      return "kcal";
    }else{
      return "g";
    }
  }
  double getMaxYvalue(int index, List<FlSpot> lineData) {
    double maxY = lineData.isNotEmpty
        ? lineData.map((spot) => spot.y).reduce((a, b) => a > b ? a : b)
        : 0;
    
    if (maxY == 0) {
      // データがすべて0の場合、適切な最小値を設定
      return index == 0 ? 300 : 3;
    }
    
    if (index == 0) {
      return maxY + (3 - (maxY % 3 == 0 ? 3 : maxY % 3)) * 100;
    } else {
      return maxY + (3 - (maxY % 3 == 0 ? 3 : maxY % 3));
    }
  }
  List<IconData> icons =[Icons.local_fire_department, Icons.fitness_center, Icons.bolt, Icons.school];
  List<String> labels = ["カロリー", "タンパク質", "脂質", "炭水化物"];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final ellipseWidth = screenWidth * 2.5;
    final ellipseHeight = screenHeight * 0.7;
    final ellipseLeft = (screenWidth - ellipseWidth) / 2;
    final ellipseTop = screenHeight * 0.4;

    final lineColor = getLineColor(selectedIndex);
    final lineData = getLineData(selectedIndex);
    final unit = getUnit(selectedIndex);
    final maxYvalue = getMaxYvalue(selectedIndex, lineData);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
               color: lineColor.withOpacity(0.5)
            ),
          ),
          Positioned(
            top: screenHeight * 0.08, 
            left: 0,
            right: 0, 
            child: Center(
              child: Text(
                labels[selectedIndex],
                style: TextStyle(
                  fontSize: screenHeight * 0.05,
                  fontWeight: FontWeight.bold,
                  color:Color.alphaBlend(Colors.black.withOpacity(0.3), lineColor),
                ),
              ),
            ),
          ),
          Positioned(
            left: ellipseLeft,
            child:CustomPaint(
              painter: ZigzagIconPainter(
                rows:10,
                columns:6,
                iconSize: screenHeight * 0.05,
                spacing: screenHeight * 0.15,
                icons: icons[selectedIndex],
                color: lineColor.withOpacity(0.4),
              ),
            ),
          ),
          Positioned(
            left: ellipseLeft,
            top: ellipseTop,
            child: Container(
              width: ellipseWidth,
              height: ellipseHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(
                  Radius.elliptical(ellipseWidth, ellipseHeight),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    offset: const Offset(0, -2),
                    blurRadius: 10,
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.15,
            left: 0,
            right: 0,
            child: NutrientSelector(
              icons: icons,
              labels: labels,
              selectedIndex: selectedIndex,
              onSelected: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
              buttonColor: lineColor,
            ),
          ),
          Positioned(
            top: ellipseTop + 80,
            left: -40,
            right: 0,
            child: Center(
              child: FLChartData(
                lineColor: lineColor,
                lineData: lineData,
                unit: unit,
                maxYValue: maxYvalue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

