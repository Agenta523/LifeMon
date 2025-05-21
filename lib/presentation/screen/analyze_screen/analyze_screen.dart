import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import './NutrientSelector.dart';
import './FLChartData.dart';

class AnalyzeScreen extends StatefulWidget {
  const AnalyzeScreen({super.key});

  @override
  State<AnalyzeScreen> createState() => _AnalyzeScreenState();
}

class _AnalyzeScreenState extends State<AnalyzeScreen> {
  int selectedIndex = 0;

  Color getLineColor(int index) {
    switch (index) {
      case 0:
        return const Color.fromARGB(255, 255, 122, 27);
      case 1:
        return const Color.fromARGB(255, 255, 123, 134);
      case 2:
        return const Color.fromARGB(255, 255, 187, 0);
      case 3:
        return const Color.fromARGB(255, 123, 134, 255); 
      default:
        return Colors.blue;
    }
  }

  List<FlSpot> getLineData(int index) {
    switch (index) {
      case 0:
        return [FlSpot(0, 2500), FlSpot(1, 2300), FlSpot(2, 2400),FlSpot(3, 2500), FlSpot(4, 2300), FlSpot(5, 2400),FlSpot(6, 2400)];
      case 1:
        return [FlSpot(0, 120), FlSpot(1, 130), FlSpot(2, 110),FlSpot(3, 100), FlSpot(4, 100), FlSpot(5, 120),FlSpot(6, 130)];
      case 2:
        return [FlSpot(0, 70), FlSpot(1, 80), FlSpot(2, 75),FlSpot(3, 60), FlSpot(4, 45), FlSpot(5, 50),FlSpot(6, 40)];
      case 3:
        return [FlSpot(0, 200), FlSpot(1, 230), FlSpot(2, 310),FlSpot(3, 250), FlSpot(4, 230), FlSpot(5, 240),FlSpot(6, 240)];
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
  double getMaxYvalue(int index, List<FlSpot> lineData){
    double? maxY = lineData.isNotEmpty ? lineData.map((spot) => spot.y).reduce((a, b) => a > b ? a : b)
    : 0;
    if(index == 0){
      return maxY + 500 + (3 - (maxY % 3 == 0 ? 3 : maxY % 3));
    }else{
      return maxY+ (3 - (maxY % 3 == 0 ? 3 : maxY % 3));
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
               gradient: LinearGradient(
                colors: [Colors.white,lineColor],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
               )
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
            top: screenHeight * 0.1,
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

