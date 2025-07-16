import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileStorage {
  static const _keyProfile = 'user_profile';
  
  Future<void> saveProfile({
    required double weight,
    required double height,
    required int age,
    required String gender,
    required int? activLevel,
    required String goal,

     }) async {
    final prefs = await SharedPreferences.getInstance();
    final profile = {
      'weight': weight,
      'height': height,
      'age': age,
      'gender': gender,   // male, female
      'activLevel': activLevel,   // 0,1,2
      'goal': goal,   // bulk, cut, maintain
    };
    final jsonStr = jsonEncode(profile);
    await prefs.setString(_keyProfile, jsonStr);
  }

  Future<Map<String, dynamic>?> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_keyProfile);
    if (jsonStr == null) return null;
    final Map<String, dynamic> profile = jsonDecode(jsonStr);
    return profile;
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyProfile);
  }
}