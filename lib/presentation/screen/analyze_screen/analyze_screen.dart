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
        return const Color(0xffFF6A00);
      case 1:
        return const Color(0xffFF7B86);
      case 2:
        return const Color(0xffFFBB00);
      case 3:
        return const Color(0xff7B86FF); 
      default:
        return Colors.blue;
    }
  }

  List<FlSpot> getLineData(int index) {
    switch (index) {
      case 0:
        return [FlSpot(0, 2500), FlSpot(1, 2300), FlSpot(2, 2400),FlSpot(3, 2500), FlSpot(4, 2300), FlSpot(5, 2400),FlSpot(6, 2400)];
      case 1:
        return [FlSpot(0, 120), FlSpot(1, 130), FlSpot(2, 110),FlSpot(3, 2500), FlSpot(4, 2300), FlSpot(5, 2400),FlSpot(6, 2400)];
      case 2:
        return [FlSpot(0, 70), FlSpot(1, 80), FlSpot(2, 75),FlSpot(3, 2500), FlSpot(4, 2300), FlSpot(5, 2400),FlSpot(6, 2400)];
      case 3:
        return [FlSpot(0, 300), FlSpot(1, 280), FlSpot(2, 310),FlSpot(3, 2500), FlSpot(4, 2300), FlSpot(5, 2400),FlSpot(6, 2400)];
      default:
        return [];
    }
  }

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

    return Scaffold(
      body: Stack(
        children: [
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
              labels: ['Cal', 'P', 'F', 'C'],
              selectedIndex: selectedIndex,
              onSelected: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
            ),
          ),
          Positioned(
            top: ellipseTop + 80,
            left: 0,
            right: 0,
            child: Center(
              child: FLChartData(
                lineColor: lineColor,
                lineData: lineData,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

