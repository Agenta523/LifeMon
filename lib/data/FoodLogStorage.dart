import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class DateValueStorage {
  static const _key = 'date_value';
  final Map<String, int> _data = {};

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_key);
    if (jsonStr != null) {
      final Map<String, dynamic> m = jsonDecode(jsonStr);
      _data
        ..clear()
        ..addEntries(m.entries.map((e) => MapEntry(e.key, e.value as int)));
      _pruneOldData();
    }
  }

  Future<void> addData(DateTime date, int value) async {
    final key = date.toIso8601String().split('T')[0];
    _data[key] = (_data[key] ?? 0) + value;
    _pruneOldData();
    await _savePrefs();
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

  Map<String, int> get data => Map.unmodifiable(_data);
}