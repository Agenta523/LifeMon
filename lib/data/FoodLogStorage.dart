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
    // ここで_formatDateKeyを使用
    final key = _formatDateKey(date);
    final dailyData = _data.putIfAbsent(key, () => {'protein': 0, 'fat': 0, 'carbo': 0});

    dailyData['protein'] = (dailyData['protein'] ?? 0) + protein;
    dailyData['fat'] = (dailyData['fat'] ?? 0) + fat;
    dailyData['carbo'] = (dailyData['carbo'] ?? 0) + carbo;
    
    _pruneOldData();
    await _savePrefs();
  }

  Map<String, int>? getDataForDate(DateTime date) {
    final key = _formatDateKey(date);
    return _data[key];
  }

  List<List<int>> getWeeklyPFCLists() {
    List<int> weeklyProteins = [];
    List<int> weeklyFats = [];
    List<int> weeklyCarbos = [];

    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);

    for (int i = 6; i >= 0; i--) {
      final DateTime date = today.subtract(Duration(days: i));
      final String key = _formatDateKey(date);
      final Map<String, int>? dailyData = _data[key];

      weeklyProteins.add(dailyData?['protein'] ?? 0);
      weeklyFats.add(dailyData?['fat'] ?? 0);
      weeklyCarbos.add(dailyData?['carbo'] ?? 0);
    }

    return [weeklyProteins, weeklyFats, weeklyCarbos];
  }

  void _pruneOldData() {
    final now = DateTime.now();
    _data.removeWhere((k, _) {
      try {
        final d = DateTime.parse(k);
        return now.difference(d).inDays >= 8;
      } catch (e) {
        return true; 
      }
    });
  }

  Future<void> _savePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(_data));
  }

  String _formatDateKey(DateTime date) {
    return date.toIso8601String().split('T')[0];
  }

  Map<String, Map<String, int>> get allData => Map.unmodifiable(_data);
}