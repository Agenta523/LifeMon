import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DateValueStorage {
  static const _key = 'date_value';

  final Map<String, Map<String, int>> _data = {};

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_key);
    if (jsonStr != null) {
      final Map<String, dynamic> m = jsonDecode(jsonStr);
      _data
        ..clear()
        ..addEntries(
          m.entries.map(
            (e) => MapEntry(
              e.key,
              Map<String, int>.from(
                (e.value as Map).map((k, v) => MapEntry(k as String, v as int)),
              ),
            ),
          ),
        );
      _pruneOldData();
    }
  }

  Future<void> addData({
    required DateTime date,
    required int protein,
    required int fat,
    required int carb,
  }) async {
    final key = _dateKey(date);

    final entry = _data[key] ?? {'protein': 0, 'fat': 0, 'carb': 0};
    entry['protein'] = (entry['protein'] ?? 0) + protein;
    entry['fat'] = (entry['fat'] ?? 0) + fat;
    entry['carb'] = (entry['carb'] ?? 0) + carb;
    _data[key] = entry;

    _pruneOldData();
    await _savePrefs();
  }

  Future<Map<String, int>> loadLatest() async {
    if (_data.isEmpty) {
      await init();
    }

    final todayKey = _dateKey(DateTime.now());
    return _data[todayKey] ?? {'protein': 0, 'fat': 0, 'carb': 0};
  }

  void _pruneOldData() {
    final now = DateTime.now();
    _data.removeWhere((k, _) {
      final d = DateTime.parse(k);
      return now.difference(d).inDays >= 5;
    });
  }

  Future<void> _savePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(_data));
  }

  Map<String, Map<String, int>> get data => Map.unmodifiable(_data);

  String _dateKey(DateTime date) => date.toIso8601String().split('T')[0];
}
