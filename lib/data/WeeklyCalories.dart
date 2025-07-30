import 'package:flutter/widgets.dart';
import 'package:life_mon/data/FoodLogStorage.dart';
import 'package:life_mon/backend/CalculateCalorie.dart';

class WeeklyCalories {
  final DateValueStorage _foodLog;
  final CalculateCalorie _calculator;

  WeeklyCalories(this._foodLog) : _calculator = CalculateCalorie(_foodLog);

  Future<void> ensureInit() async {
    WidgetsFlutterBinding.ensureInitialized();
    await _foodLog.init();
  }

  Future<List<int>> saveLast7DaysAndReturnList() async {
    await ensureInit();

    final now   = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final List<int> dailyList = [];

    for (var offset = 0; offset < 7; offset++) {
      final date = today.subtract(Duration(days: offset));
      final cals = _calculator.caloriesOn(date);

      final existing = _foodLog.getDataForDate(date);
      existing['calories'] = cals;
      await _foodLog.setDataForDate(date, existing);

      debugPrint('[DailyCalories] ${date.toIso8601String().split("T")[0]} → $cals kcal');
      dailyList.add(cals);
    }

    final weeklyTotal = dailyList.reduce((a, b) => a + b);
    debugPrint('[WeeklyCalories] Past 7 days total → $weeklyTotal kcal');
    return dailyList.reversed.toList();
  }
}