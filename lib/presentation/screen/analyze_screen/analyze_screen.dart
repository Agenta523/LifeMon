import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalyzeScreen extends StatefulWidget {
  const AnalyzeScreen({super.key});

  @override
  State<AnalyzeScreen> createState() => _AnalyzeScreenState();
}

class _AnalyzeScreenState extends State<AnalyzeScreen> {
  int selectedIndex = 0;

  Color getLineColor(int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        return const Color(0xffFF6A00);
      case 1:
        return const Color(0xffFF7B86);
      case 2:
        return const Color(0xffFFBB00);
      case 3:
        return const Color(0xffFF7B86); 
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

class NutrientSelector extends StatelessWidget {
  final List<String> labels;
  final int selectedIndex;
  final Function(int) onSelected;

  const NutrientSelector({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(labels.length, (index) {
        final isSelected = selectedIndex == index;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ElevatedButton(
            onPressed: () => onSelected(index),
            style: ElevatedButton.styleFrom(
              backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
              foregroundColor: isSelected ? Colors.white : Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(labels[index]),
          ),
        );
      }),
    );
  }
}

class FLChartData extends StatelessWidget {
  final Color lineColor;
  final List<FlSpot> lineData;

  const FLChartData({
    super.key,
    required this.lineColor,
    required this.lineData,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    const double maxYValue = 3000;

    return SizedBox(
      width: screenWidth * 0.95,
      height: screenHeight * 0.4,
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: maxYValue,
          lineBarsData: [
            LineChartBarData(
              spots: lineData,
              isCurved: true,
              color: lineColor,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) =>
                    FlDotCirclePainter(
                  radius: 3.0,
                  color: lineColor,
                  strokeWidth: 2.0,
                  strokeColor: lineColor,
                ),
              ),
              barWidth: 3,
            ),
          ],
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: maxYValue / 3,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: const Color(0xffCDCDCD),
                strokeWidth: 2.0,
              );
            },
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              axisNameWidget: const Text("曜日", style: TextStyle(color: Color(0xffCDCDCD))),
              axisNameSize: 22.0,
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1.0,
                reservedSize: 40.0,
                getTitlesWidget: bottomTitleWidgets,
              ),
            ),
            leftTitles: AxisTitles(
              axisNameWidget: const Text("kcal", style: TextStyle(color: Color(0xffCDCDCD))),
              sideTitles: SideTitles(showTitles: true, reservedSize: 40.0),
            ),
            topTitles: AxisTitles(),
            rightTitles: AxisTitles(),
          ),
        ),
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff68737d),
      fontWeight: FontWeight.bold,
      fontSize: 16.0,
    );

    final labels = ['月', '火', '水', '木', '金', '土', '日'];

    Widget text = Text(
      value.toInt() < labels.length ? labels[value.toInt()] : '',
      style: style,
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }
}