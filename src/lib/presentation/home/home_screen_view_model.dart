import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:src/data/random_number.dart';
import 'package:src/domain/random_number_logic.dart';

part 'home_screen_view_model.g.dart';

@riverpod
class HomeScreenViewModel extends _$HomeScreenViewModel {

  @override
  int build() {
    return 0;
  }

  Future<int?> generateRandomNumber(int start , int end) async {
    // 画面のローディングが認識できるようににあえて1秒待つ
    await Future.delayed(const Duration(seconds: 1));

    final logic = ref.read(randomNumberLogicProvider);
    return logic.generateRandomNumber(start, end);
  }

  Future<RandomNumber> fetchRandomNumber() async {
    final logic = ref.read(randomNumberLogicProvider);
    return logic.fetchRandomNumber();
  }

  Future<void> changeStartNumber(int start) async {
    final logic = ref.read(randomNumberLogicProvider);
    await logic.changeStart(start);
  }

  Future<void> changeEndNumber(int end) async {
    final logic = ref.read(randomNumberLogicProvider);
    await logic.changeEnd(end);
  }

  Future<void> cleanCache() async {
    final logic = ref.read(randomNumberLogicProvider);
    await logic.cleanCache();
  }
}