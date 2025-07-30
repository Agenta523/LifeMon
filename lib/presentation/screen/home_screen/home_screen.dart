import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

import 'package:life_mon/presentation/screen/home_screen/widget/character_info.dart';
import 'package:life_mon/data/UserProfileStorage.dart';
import 'package:life_mon/presentation/widget/calorie_bar.dart';
import 'package:life_mon/presentation/widget/body_icon.dart';
import 'package:life_mon/presentation/screen/profile_screen/profile_screen.dart';
import 'package:life_mon/presentation/screen/home_screen/widget/character_display.dart';
import 'package:life_mon/presentation/screen/home_screen/widget/character_selection_dialog.dart';
import 'package:life_mon/presentation/screen/home_screen/widget/character_grid_dialog.dart';
import 'package:life_mon/presentation/screen/home_screen/widget/user_profile_header.dart';
import 'package:life_mon/backend/PfcService.dart';
import 'package:life_mon/data/FoodLogStorage.dart';
import 'package:life_mon/backend/CalorieService.dart';
import 'package:life_mon/backend/CalculateCalorie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  // Data
  final UserProfileStorage _userProfileStorage = UserProfileStorage();
  final DateValueStorage _foodLogStorage = DateValueStorage();
  late final PfcService _pfcService;
  late final calorieService _calorieService;
  late final CalculateCalorie _calculateCalorie;

  final List<CharacterInfo> characters = [
    CharacterInfo(
      name: 'モフィメット',
      description: '元気でやさしい筋トレ好きキャラ',
      riveFile: 'lib/presentation/images/mofumetto.riv',
      iconImage: 'lib/presentation/images/mofumetto.png',
    ),
    CharacterInfo(
      name: 'テディキャット',
      description: '冷静で賢い分析キャラ',
      riveFile: 'lib/presentation/images/cat.riv',
      iconImage: 'lib/presentation/images/cat.png',
    ),
    CharacterInfo(
      name: 'モフィメット',
      description: '植物と話す自然派キャラ',
      riveFile: 'lib/presentation/images/mofumetto.riv',
      iconImage: 'lib/presentation/images/mofumetto.png',
    ),
  ];

  final List<IconData> icons = [Icons.fitness_center, Icons.bolt, Icons.school];
  final List<String> labels = ["タンパク質", "脂質", "炭水化物"];
  final List<Color> colors_list = [
    const Color.fromARGB(255, 255, 123, 134),
    const Color.fromARGB(255, 255, 187, 0),
    const Color.fromARGB(255, 123, 134, 255),
  ];
  List<int> eat_value_base = [0, 0, 0];
  List<int> eat_value = [0, 0, 0];
  int selectedIndex = 0;

  int _targetCalories = 0;
  int _currentCalories = 0;

  // Character State
  int selectedCharacterIndex = 0;
  Artboard? _artboard;
  RiveAnimationController? _controller;
  late AnimationController _animationController;
  late Animation<double> _xAnimation;
  late Animation<double> _yAnimation;
  double? characterX;
  double? characterY;
  bool isFacingLeft = false;
  final double characterSize = 200.0;

  // Profile State
  String height = "";
  String age = "";
  String sex = "男";
  int? selectedActivityIndex;
  String goalType = "増量";
  String weight = "";

  @override
  void initState() {
    super.initState();
    _pfcService = PfcService(_userProfileStorage);
    _calorieService = calorieService(_userProfileStorage); // 追加
    _calculateCalorie = CalculateCalorie(_foodLogStorage); // 追加
    _loadAllData();

    _animationController =
        AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 1500),
          )
          ..addListener(_updateCharacterPosition)
          ..addStatusListener(_handleAnimationStatus);

    // アプリ起動時に全データを読み込む
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    await _foodLogStorage.init(); // 食事ログの初期化が最初
    await _loadProfileData(); // 次にプロフィールと目標値を読み込む
    await loadTodaysNutrition(); // 最後に今日の摂取量を読み込む
  }

  // 全目標値を計算
  Future<void> _updateAllTargets() async {
    // 目標PFCを計算
    final pfcTarget = await _pfcService.calculatePfcTarget();
    // 目標カロリーを計算
    final calorieTarget = await _calorieService.DailyCalorie();

    if (mounted) {
      setState(() {
        if (pfcTarget != null) {
          eat_value_base = [
            pfcTarget.proteinGram.round(),
            pfcTarget.fatGram.round(),
            pfcTarget.carboGram.round(),
          ];
        }
        _targetCalories = calorieTarget?.round() ?? 0;
      });
      debugPrint("✅ PFC Target Updated: $eat_value_base");
      debugPrint("✅ Calorie Target Updated: $_targetCalories kcal");
    }
  }

  //今日のPFC摂取量を取得してeat_valueを更新するメソッド
  Future<void> loadTodaysNutrition() async {
    await _foodLogStorage.init(); // SharedPreferencesからデータをロード
    final today = DateTime.now();
    final todaysData = _foodLogStorage.getDataForDate(today);
    final calorieTarget = await _calorieService.DailyCalorie();
    _targetCalories = calorieTarget?.round() ?? 0;
    _currentCalories = _calculateCalorie.caloriesOn(today);

    if (mounted && todaysData != null) {
      setState(() {
        // labelsの順序「タンパク質, 脂質, 炭水化物」に合わせて更新
        if (todaysData != null) {
          eat_value = [
            todaysData['protein'] ?? 0,
            todaysData['fat'] ?? 0,
            todaysData['carbo'] ?? 0,
          ];
        } else {
          eat_value = [0, 0, 0];
        }
        // 今日の摂取カロリーを計算
        _currentCalories = _calculateCalorie.caloriesOn(today);
      });
      debugPrint("✅ Today's Nutrition Loaded: $eat_value");
    }
  }

  // --- プロフィールデータの読み込み専用メソッド ---
  Future<void> _loadProfileData() async {
    final profile = await UserProfileStorage().loadProfile();
    if (profile != null) {
      setState(() {
        selectedActivityIndex = profile['activLevel'];
        goalType = profile['goal'];
        weight = profile['weight']?.toString() ?? "";
        height = profile['height']?.toString() ?? "";
        age = profile['age']?.toString() ?? "";
        sex = profile['gender'] ?? "男";
      });

      //プロフィール読み込み後にPFCを計算・更新
      await _updateAllTargets();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (characterX == null) {
      final size = MediaQuery.of(context).size;
      characterX = (size.width / 2) - (characterSize / 2);
      characterY = (size.height / 2) - (characterSize / 2);
    }
    _loadRive(characters[selectedCharacterIndex].riveFile);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _controller?.dispose();
    super.dispose();
  }

  // --- Core Logic Methods ---

  Future<void> _loadRive(String path) async {
    final data = await rootBundle.load(path);
    final file = RiveFile.import(data);
    final artboard = file.mainArtboard;

    if (_controller != null) {
      artboard.removeController(_controller!);
      _controller!.dispose();
    }

    final newController = SimpleAnimation('state');
    artboard.addController(newController);

    setState(() {
      _artboard = artboard;
      _controller = newController;
    });
  }

  void _moveCharacterTo(Offset target) {
    if (_artboard == null) return;

    setState(() {
      isFacingLeft = target.dx < characterX!;
    });

    if (_controller != null) {
      _artboard!.removeController(_controller!);
    }

    final walkController = SimpleAnimation('walk');
    _artboard!.addController(walkController);
    _controller = walkController;

    _xAnimation = Tween<double>(
      begin: characterX!,
      end: target.dx,
    ).animate(_animationController);
    _yAnimation = Tween<double>(
      begin: characterY!,
      end: target.dy,
    ).animate(_animationController);

    _animationController.forward(from: 0.0);
  }

  void _updateCharacterPosition() {
    setState(() {
      characterX = _xAnimation.value;
      characterY = _yAnimation.value;
    });
  }

  void _handleAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      if (_controller != null) {
        _artboard?.removeController(_controller!);
      }

      final idleController = SimpleAnimation('state');
      _artboard?.addController(idleController);
      _controller = idleController;
    }
  }

  void _onCharacterSelected(int index) {
    if (selectedCharacterIndex == index) return;
    setState(() {
      selectedCharacterIndex = index;
    });
    _loadRive(characters[index].riveFile);
  }

  // --- Dialog Methods ---
  void _showCharacterSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return CharacterSelectionDialog(
          characters: characters,
          initialIndex: selectedCharacterIndex,
          onCharacterSelected: _onCharacterSelected,
          onSwitchToGrid: () {
            Navigator.pop(context);
            _showCharacterGridSelectionDialog();
          },
        );
      },
    );
  }

  void _showCharacterGridSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return CharacterGridDialog(
          characters: characters,
          onCharacterSelected: _onCharacterSelected,
          onGoBack: () {
            Navigator.pop(context);
            _showCharacterSelectionDialog();
          },
        );
      },
    );
  }

  // --- マージされた _openProfileDialog メソッド ---
  void _openProfileDialog() async {
    // モーダル表示前に最新のデータを読み込む
    await _loadProfileData();

    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 1.0,
          child: Profile(
            initialActivityIndex: selectedActivityIndex,
            initialGoalType: goalType,
            initialWeight: weight,
            initialHeight: height,
            initialAge: age,
            initialSex: sex,
          ),
        );
      },
    );

    // 結果が返ってきたら、データを保存し、UIを更新する
    if (result != null) {
      // データを永続化
      await UserProfileStorage().saveProfile(
        weight: double.tryParse(result['weight'] ?? '0') ?? 0,
        height: double.tryParse(result['height'] ?? '0') ?? 0,
        age: int.tryParse(result['age'] ?? '0') ?? 0,
        gender: result['sex'],
        activLevel: result['activityIndex'],
        goal: result['goalType'],
      );

      // UIを即時反映するためにStateを更新
      setState(() {
        selectedActivityIndex = result['activityIndex'];
        goalType = result['goalType'];
        weight = result['weight'];
        height = result['height'];
        age = result['age'];
        sex = result['sex'];
      });

      //プロフィール更新後にPFCを再計算・更新
      await _updateAllTargets();

      debugPrint("✅ Profile Saved & State Updated: $result");
    }
  }

  // --- Build Method ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'lib/presentation/images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown:
                  (details) => _moveCharacterTo(
                    Offset(
                      details.localPosition.dx - characterSize / 2,
                      details.localPosition.dy - characterSize / 2,
                    ),
                  ),
            ),
          ),
          if (_artboard != null && characterX != null && characterY != null)
            CharacterDisplay(
              artboard: _artboard!,
              x: characterX!,
              y: characterY!,
              size: characterSize,
              isFacingLeft: isFacingLeft,
            ),
          UserProfileHeader(onTap: _openProfileDialog),
          Positioned(
            top: 40,
            right: 20,
            child: GestureDetector(
              onTap: _showCharacterSelectionDialog,
              child: CircleAvatar(
                backgroundImage: AssetImage(
                  characters[selectedCharacterIndex].iconImage,
                ),
                radius: 25,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CalorieBar(
                calorieValue: _currentCalories,
                calorieTarget: _targetCalories,
              ),
              BodyIcons(
                icons: icons,
                labels: labels,
                colors_list: colors_list,
                selectedIndex: selectedIndex,
                icons_length: icons.length,
                eat_values: eat_value,
                eat_values_base: eat_value_base,
                onSelected: (index) => setState(() => selectedIndex = index),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
