import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:life_mon/data/UserProfileStorage.dart';

class bmiService {
  final UserProfileStorage _storage;
  bmiService(this._storage);

  Future<void> ensureInit() async {
    WidgetsFlutterBinding.ensureInitialized();
  }

  Future<double?> UserBmi() async {
    final profile = await _storage.loadProfile();
    if (profile == null) return null;

    final weight = (profile['weight'] as num).toDouble();
    final height = (profile['height'] as num).toDouble();

    final heightM = height * 0.01;
    final bmi = weight / (heightM * heightM);
    return bmi;
  }
}
