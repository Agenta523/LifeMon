import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:life_mon/data/UserProfileStorage.dart';

class calorieService {
    final UserProfileStorage _storage;
    calorieService(this._storage);

    Future<void> ensureInit() async {
        WidgetsFlutterBinding.ensureInitialized();
    }

    Future<double?> DailyCalorie() async {
        final profile = await _storage.loadProfile();
        if (profile == null) return null;

        final weight = (profile['weight'] as num).toDouble();
        final height = (profile['height'] as num).toDouble();
        final age = (profile['age'] as num).toDouble();
        final gender = (profile['gender'] as String).toString();
        final activLevel = (profile['gender'] as String).toString();
        final goal = (profile['gender'] as String).toString();

        // 基礎代謝推定
        double baseMetabo;
        if (gender == "male") {
          baseMetabo = (0.0481 * weight + 0.0234 * height - 0.0138 * age - 0.4235) * 1000 / 4.186;
        } else if (gender == "female") {
          baseMetabo = (0.0481 * weight + 0.0234 * height - 0.0138 * age - 0.4235) * 1000 / 4.186;
        } else {
          throw ArgumentError('不正な性別: $gender');
        }
        print(activLevel);

        // 目標摂取カロリー推定
        double multiplier;
        if (activLevel == "I") {
          multiplier = 1.5;
        } else if (activLevel == "II") {
          multiplier = 1.75;
        } else if (activLevel == "III") {
          multiplier = 2.0;
        } else {
          throw ArgumentError('不正な活動レベル: $activLevel');
        }

        int adjustment;
        if (goal == "bulk") {
          adjustment = 300;
        } else if (goal == "maintain") {
          adjustment = 0;
        } else if (goal == "cut") {
          adjustment = -300;
        } else {
          throw ArgumentError('不正な目標: $goal');
        }

        return baseMetabo * multiplier + adjustment;
    }
}