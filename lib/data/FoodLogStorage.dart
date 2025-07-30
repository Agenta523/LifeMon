import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 日付ごとの栄養摂取データを保存・読み出しするストレージクラス
/// PFC（Protein, Fat, Carbohydrate）の摂取量を日付キーで管理
class DateValueStorage {
  static const _key = 'daily_nutrition_data';
  final Map<String, Map<String, int>> _data = {};

  /// SharedPreferences から既存データを読み込んで初期化
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

  Future<void> setDataForDate(
  DateTime date,
  Map<String, int> data,
  ) async {
    final key   = _formatDateKey(date);
    // 内部マップにも反映
    _data[key] = {
      'protein': data['protein'] ?? 0,
      'fat':     data['fat']     ?? 0,
      'carbo':   data['carbo']   ?? 0,
      // もしカロリー単独で保存したいなら 'calories': data['calories'] as int,
    };
    await _savePrefs();
  }

  /// 指定日の栄養摂取データを追加（加算）して保存
  Future<void> addData(
    DateTime date,
    {
      int protein = 0,
      int fat = 0,
      int carbo = 0,
    }
  ) async {
    final key = _formatDateKey(date);
    final dailyData = _data.putIfAbsent(
      key,
      () => {'protein': 0, 'fat': 0, 'carbo': 0},
    );

    dailyData['protein'] = (dailyData['protein'] ?? 0) + protein;
    dailyData['fat']     = (dailyData['fat']     ?? 0) + fat;
    dailyData['carbo']   = (dailyData['carbo']   ?? 0) + carbo;

    _pruneOldData();
    await _savePrefs();
  }

  /// 指定日のデータを取得。未登録時は全て0を返す
  Map<String, int> getDataForDate(DateTime date) {
    final key = _formatDateKey(date);
    final daily = _data[key];
    return {
      'protein': daily?['protein'] ?? 0,
      'fat':     daily?['fat']     ?? 0,
      'carbo':   daily?['carbo']   ?? 0,
    };
  }

  /// 直近7日間の PFC リストを取得
  /// 戻り値は [proteins, fats, carbos] の3リスト
  List<List<int>> getWeeklyPFCLists() {
    final List<int> weeklyProteins = [];
    final List<int> weeklyFats     = [];
    final List<int> weeklyCarbos   = [];

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    for (int i = 6; i >= 0; i--) {
      final date = today.subtract(Duration(days: i));
      final key = _formatDateKey(date);
      final data = _data[key];
      weeklyProteins.add(data?['protein'] ?? 0);
      weeklyFats.add(data?['fat'] ?? 0);
      weeklyCarbos.add(data?['carbo'] ?? 0);
    }

    return [weeklyProteins, weeklyFats, weeklyCarbos];
  }

  /// データの古いエントリ（8日以上前）を削除
  void _pruneOldData() {
    final now = DateTime.now();
    _data.removeWhere((k, _) {
      try {
        final d = DateTime.parse(k);
        return now.difference(d).inDays >= 8;
      } catch (_) {
        return true;
      }
    });
  }

  /// SharedPreferences に保存
  Future<void> _savePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(_data);
    final success = await prefs.setString(_key, jsonString);
    if (success) {
      debugPrint('[DateValueStorage] Saved data: $jsonString');
    } else {
      debugPrint('[DateValueStorage] ⚠️ Failed to save prefs.');
    }
  }

  /// 日付キーを "YYYY-MM-DD" 形式にフォーマット
  String _formatDateKey(DateTime date) {
    return date.toIso8601String().split('T')[0];
  }

  /// 全データへの読み取り専用アクセス
  Map<String, Map<String, int>> get allData => Map.unmodifiable(_data);
}