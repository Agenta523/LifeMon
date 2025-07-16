import 'package:shared_preferences/shared_preferences.dart';

class EnergyRepository {
  static const String _proteinKey = 'protein';
  static const String _fatKey = 'fat';
  static const String _carbKey = 'carb';
  static const String _dateKey = 'date';

  Future<void> save({
    required String protein,
    required String fat,
    required String carb,
    required String date,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_proteinKey, protein);
    await prefs.setString(_fatKey, fat);
    await prefs.setString(_carbKey, carb);
    await prefs.setString(_dateKey, date);
  }

  Future<Map<String, String>> load() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'protein': prefs.getString(_proteinKey) ?? '',
      'fat': prefs.getString(_fatKey) ?? '',
      'carb': prefs.getString(_carbKey) ?? '',
      'date': prefs.getString(_dateKey) ?? '',
    };
  }
}
