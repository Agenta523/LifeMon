import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:life_mon/data/UserProfileStorage.dart';
import 'package:life_mon/backend/CalorieService.dart';
import 'package:life_mon/backend/PfcService.dart';

void main() {
  // Flutter プラグインをテスト環境で使うための初期化
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    // SharedPreferences のモック初期値を空でセット
    SharedPreferences.setMockInitialValues({});
  });

  test('CalorieService.calculateCalories が正しい目標カロリーを返す＆printできる', () async {
    final storage = UserProfileStorage();

    // テスト用データを保存 (体重, 身長, 年齢, 性別, 活動レベル, 目標)
    await storage.saveProfile(
      weight: 60,
      height: 170,
      age: 30,
      gender: 'male',   // male, female
      activLevel: 3,   // I, II, III
      goal: 'cut',   // bulk, cut, maintain
    );

    final calorie_service = calorieService(storage);
    await calorie_service.ensureInit();
    final calories = await calorie_service.DailyCalorie();
    final pfc_service = PfcService(storage);
    final target  = await pfc_service.calculatePfcTarget();

    print('Test output — Calories: ${calories?.toStringAsFixed(2)}');
    print('PFC Target - P:${target?.proteinGram}, F:${target?.fatGram}, C:${target?.carboGram}');
    expect(target, isNotNull);
    expect(calories, isNotNull);
    expect(calories!, closeTo(2219.44, 1));
  });
}