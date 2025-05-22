import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class FLChartData extends StatelessWidget {
  final Color lineColor;
  final List<FlSpot> lineData;
  final String unit;
  final double maxYValue;

  const FLChartData({
    super.key,
    required this.lineColor,
    required this.lineData,
    required this.unit,
    required this.maxYValue,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final scale = maxYValue / 3;

    return SizedBox(
      width: screenWidth * 0.9,
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
            horizontalInterval: scale,
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
              axisNameWidget: Padding(
                padding: const EdgeInsets.only(left: 60),
                child:Align(
                  alignment: Alignment.center,
                  child: const Text("曜日", style: TextStyle(color: Color(0xffCDCDCD))),
                ) 
              ) ,          
              axisNameSize: 22.0,
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1.0,
                reservedSize: 40.0,
                getTitlesWidget: bottomTitleWidgets,
              ),
            ),
            leftTitles: AxisTitles(
              axisNameSize: 22.0, 
              axisNameWidget:Padding(
                padding: const EdgeInsets.only(left: 60),
                child:Align(
                  alignment: Alignment.center,
                  child: Text(unit, style: TextStyle(color: Color(0xffCDCDCD))),
                ),
              ),               
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40.0,
                interval: scale,
              ),
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
    int todayIndex = DateTime.now().weekday - 1;

    List<String> reorderedLabels = [
      for (int i = 1; i <= 7; i++) labels[(todayIndex + i) % 7]
    ];

    String label = '';
    int index = value.toInt();
    if (index >= 0 && index < reorderedLabels.length) {
      label = reorderedLabels[index];
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(label, style: style),
    );
  }
}