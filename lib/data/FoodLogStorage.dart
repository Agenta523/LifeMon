import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DateValueStorage {
  static const _key = 'daily_nutrition_data';
  final Map<String, Map<String, int>> _data = {};

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_key);
    if (jsonStr != null) {
      final Map<String, dynamic> decodedMap = jsonDecode(jsonStr);
      _data.clear();
      decodedMap.forEach((key, value) {
        if (value is Map<String, dynamic>) {
          _data[key] = value.cast<String, int>();
        }
      });
      _pruneOldData();
    }
  }

  Future<void> addData(DateTime date, {int protein = 0, int fat = 0, int carbo = 0}) async {
    final key = date.toIso8601String().split('T')[0]; 
    final dailyData = _data.putIfAbsent(key, () => {'protein': 0, 'fat': 0, 'carbo': 0});

    dailyData['protein'] = (dailyData['protein'] ?? 0) + protein;
    dailyData['fat'] = (dailyData['fat'] ?? 0) + fat;
    dailyData['carbo'] = (dailyData['carbo'] ?? 0) + carbo;
    
    _pruneOldData();
    await _savePrefs();
  }

  Map<String, int>? getDataForDate(DateTime date) {
    final key = date.toIso8601String().split('T')[0];
    return _data[key];
  }

  void _pruneOldData() {
    final now = DateTime.now();
    _data.removeWhere((k, _) {
      try {
        final d = DateTime.parse(k);
        return now.difference(d).inDays >= 5;
      } catch (e) {
        return true; 
      }
    });
  }

  Future<void> _savePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(_data));
  }

  Map<String, Map<String, int>> get allData => Map.unmodifiable(_data);
}