import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:src/domain/random_number_logic.dart';

part 'home_screen_view_model.g.dart';

@riverpod
class HomeScreenViewModel extends _$HomeScreenViewModel {

  @override
  int build() {
    return 0;
  }

  Future<int?> generateRandomNumber(int start , int end) async {
    final logic = ref.read(randomNumberLogicProvider);
    return logic.generateRandomNumber(start, end);
  }

  Future<void> cleanCache() async {
    // TODO: キャッシュのクリア処理を実装
  }
}