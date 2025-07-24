import 'package:flutter/widgets.dart';
import 'package:life_mon/data/UserProfileStorage.dart';
import 'package:life_mon/backend/CalorieService.dart';
import 'package:life_mon/data/PfcTargetStorage.dart';

class PfcService {
  final UserProfileStorage _storage;
  final calorieService _calorieService;

  PfcService(this._storage) : _calorieService = calorieService(_storage);

  Future<void> ensureInit() async {
    WidgetsFlutterBinding.ensureInitialized();
  }

  Future<PfcTarget?> calculatePfcTarget() async {
    await ensureInit();

    // 目標摂取カロリー取得
    final calories = await _calorieService.DailyCalorie();
    if (calories == null) return null;

    // 目標取得
    final profile = await _storage.loadProfile();
    if (profile == null) return null;
    final goal = profile['goal'] as String;

    // PFCパーセンテージ選択
    double proteinRatio, fatRatio, carboRatio;
    switch (goal) {
      case '減量':
        proteinRatio = (0.25 + 0.40) / 2; // 平均: 32.5%
        fatRatio = 0.20;
        carboRatio = (0.40 + 0.55) / 2; // 平均: 47.5%
        break;
      case '増量':
        proteinRatio = (0.30 + 0.35) / 2; // 平均: 32.5%
        fatRatio = 0.20;
        carboRatio = (0.45 + 0.50) / 2; // 平均: 47.5%
        break;
      case 'maintain':
        proteinRatio = (0.13 + 0.20) / 2; // 平均: 16.5%
        fatRatio = (0.20 + 0.30) / 2; // 平均: 25%
        carboRatio = (0.50 + 0.65) / 2; // 平均: 57.5%
        break;
      default:
        throw ArgumentError('不正な目標 from PfcService: $goal');
    }

    // Pfcグラム計算
    final proteinGram = calories * proteinRatio / 4;
    final fatGram = calories * fatRatio / 9;
    final carboGram = calories * carboRatio / 4;

    return PfcTarget(
      proteinGram: proteinGram,
      fatGram: fatGram,
      carboGram: carboGram,
    );
  }
}
