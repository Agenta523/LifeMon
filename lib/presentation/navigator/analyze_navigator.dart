import 'package:flutter/material.dart';
import '../screen/analyze_screen/analyze_screen.dart';

class AnalyzeNavigator extends StatelessWidget {
  const AnalyzeNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(builder: (context) => const AnalyzeScreen());
      },
    );
  }
}
