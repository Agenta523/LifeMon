import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import './NutrientSelector.dart';
import './FLChartData.dart';
import './zigzagIconPainter.dart';
import 'package:life_mon/data/FoodLogStorage.dart'; // DateValueStorageクラスのパス

/// DateValueStorageのインスタンス。アプリ全体で利用。
final DateValueStorage _storage = DateValueStorage();

/// 栄養分析画面のウィジェット。
class AnalyzeScreen extends StatefulWidget {
  const AnalyzeScreen({super.key});

  @override
  State<AnalyzeScreen> createState() => _AnalyzeScreenState();
}

/// AnalyzeScreenのステートを管理するクラス。
class _AnalyzeScreenState extends State<AnalyzeScreen> {
  /// 現在選択されている栄養素のインデックス。
  int selectedIndex = 0;
  List<int> calorie = List.filled(7, 0);
  List<int> carbo = List.filled(7, 0);
  List<int> fat = List.filled(7, 0);
  List<int> protein = List.filled(7, 0);

  @override
  void initState() {
    super.initState();
    _loadNutrientData(); // 画面初期化時に栄養素データを読み込む。
  }

  /// 週次栄養素データを非同期で読み込み、Stateを更新する。
  Future<void> _loadNutrientData() async {
    await _storage.init(); //ストレージを初期化（保存されたデータをロード）。

    // 週ごとのPFCデータリストを取得。
    List<List<int>> pfcListsFromStorage = _storage.getWeeklyPFCLists();

    setState(() {
      // 取得したPFCデータを各リストに格納。
      protein = pfcListsFromStorage[0];
      fat = pfcListsFromStorage[1];
      carbo = pfcListsFromStorage[2];
      //calorie = ;
    });
  }

  Color getLineColor(int index) {
    switch (index) {
      case 0: // カロリーの色
        return const Color.fromARGB(255, 253, 163, 120);
      case 1: // タンパク質の色
        return const Color.fromARGB(255, 255, 123, 134);
      case 2: // 脂質の色
        return const Color.fromARGB(255, 255, 187, 0);
      case 3: // 炭水化物の色
        return const Color.fromARGB(255, 123, 134, 255);
      default:
        return Colors.blue;
    }
  }

  List<FlSpot> getLineData(int index) {
    switch (index) {
      case 0: // カロリーのFlSpotデータ
        return List.generate(calorie.length, (i) => FlSpot(i.toDouble(), calorie[i].toDouble()));
      case 1: // タンパク質のFlSpotデータ
        return List.generate(protein.length, (i) => FlSpot(i.toDouble(), protein[i].toDouble()));
      case 2: // 脂質のFlSpotデータ
        return List.generate(fat.length, (i) => FlSpot(i.toDouble(), fat[i].toDouble()));
      case 3: // 炭水化物のFlSpotデータ
        return List.generate(carbo.length, (i) => FlSpot(i.toDouble(), carbo[i].toDouble()));
      default:
        return [];
    }
  }

  /// 選択されたインデックスに基づいて単位文字列を返す
  String getUnit(int index) {
    if (index == 0) {
      return "kcal";
    } else {
      return "g";
    }
  }

  /// グラフのY軸の最大値を計算して返す
  double getMaxYvalue(int index, List<FlSpot> lineData) {
    // データの最大値を取得、データが空の場合は0
    double maxY = lineData.isNotEmpty
        ? lineData.map((spot) => spot.y).reduce((a, b) => a > b ? a : b)
        : 0;

    // データがすべて0の場合のデフォルト最大値を設定
    if (maxY == 0) {
      return index == 0 ? 300.0 : 30.0;
    }

    // グラフの最大値を切り上げて調整
    if (index == 0) { 
      return (maxY / 100).ceil() * 100.0;
    } else { 
      return (maxY / 10).ceil() * 10.0;
    }
  }

  /// 栄養素選択ボタンに表示されるアイコンのリスト。
  List<IconData> icons = [Icons.local_fire_department, Icons.fitness_center, Icons.bolt, Icons.school];
  /// 栄養素選択ボタンに表示されるラベルのリスト。
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
          /// 画面全体の背景色。
          Container(
            decoration: BoxDecoration(
              color: lineColor.withOpacity(0.5),
            ),
          ),
          /// 画面上部の栄養素ラベル表示。
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
                  color: Color.alphaBlend(Colors.black.withOpacity(0.3), lineColor),
                ),
              ),
            ),
          ),
          /// 背景のジグザグアイコンパターン。
          Positioned(
            left: ellipseLeft,
            child: CustomPaint(
              painter: ZigzagIconPainter(
                rows: 10,
                columns: 6,
                iconSize: screenHeight * 0.05,
                spacing: screenHeight * 0.15,
                icons: icons[selectedIndex],
                color: lineColor.withOpacity(0.4),
              ),
            ),
          ),
          /// 中央下部の白い楕円形背景。
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
          /// 栄養素選択ボタン群。
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
          /// 栄養素グラフデータ表示部分。
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