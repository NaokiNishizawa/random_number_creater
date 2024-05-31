import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:src/domain/random_number_logic.dart';

part 'ignore_numbers_view_model.g.dart';

@riverpod
class IgnoreNumbersViewModel extends _$IgnoreNumbersViewModel {

  @override
  int build() {
    return 0;
  }

  Future<List<int>> fetchIgnoreNumberList() async {
    // 画面のローディングが認識できるようににあえて500ミリ秒待つ
    await Future.delayed(const Duration(milliseconds: 500));

    final logic = ref.read(randomNumberLogicProvider);
    return logic.fetchIgnoreNumberList();
  }

  Future<void> addIgnoreNumber(int newValue) async {
    final logic = ref.read(randomNumberLogicProvider);
    await logic.addIgnoreNumber(newValue);
  }

  Future<void> removeIgnoreNumber(int newValue) async {
    final logic = ref.read(randomNumberLogicProvider);
    await logic.removeIgnoreNumber(newValue);
  }
}