import 'package:flutter/widgets.dart';
import 'package:life_mon/data/FoodLogStorage.dart';

class CalculateCalorie {
  final DateValueStorage _foodLog;
  CalculateCalorie(this._foodLog);

  Future<void> ensureInit() async {
    WidgetsFlutterBinding.ensureInitialized();
    await _foodLog.init();
  }

  int caloriesOn(DateTime date) {
    final daily = _foodLog.getDataForDate(date);
    final p = daily['protein'] ?? 0;
    final f = daily['fat']     ?? 0;
    final c = daily['carbo']   ?? 0;
    final calories = p * 4 + f * 9 + c * 4;

    // final day = date.toIso8601String().split('T')[0];
    // debugPrint('[DailyCalories] $day → $calories kcal');
    return calories;
  }
}