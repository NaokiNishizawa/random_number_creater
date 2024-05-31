import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:src/domain/random_number_logic.dart';

part 'current_status_view_model.g.dart';

@riverpod
class CurrentStatusViewModel extends _$CurrentStatusViewModel {

  @override
  List<int> build() {
    return [];
  }

  Future<List<int>> fetch() async {
    // 画面のローディングが認識できるようににあえて500ミリ秒待つ
    await Future.delayed(const Duration(milliseconds: 500));
    final logic = ref.read(randomNumberLogicProvider);
    final result = await logic.getCacheNumberList();
    return result ?? [];
  }
}