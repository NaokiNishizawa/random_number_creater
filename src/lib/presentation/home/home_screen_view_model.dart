import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_screen_view_model.g.dart';

@riverpod
class HomeScreenViewModel extends _$HomeScreenViewModel {

  @override
  int build() {
    return 0;
  }

  int generateRandomNumber(int start , int end) {
    final random = Random().nextInt((end +1) - start);
    return random + start;
  }

  Future<void> cleanCache() async {
    // TODO: キャッシュのクリア処理を実装
  }
}