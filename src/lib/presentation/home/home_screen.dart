import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:src/core/router/router_info.dart';
import 'package:src/data/random_number.dart';
import 'package:src/extenstion/context_extenstion.dart';
import 'package:src/presentation/home/home_screen_view_model.dart';
import 'package:src/presentation/home/widgets/home_context_menu_button.dart';
import 'package:src/utils/consts.dart';

class HomeScreen extends HookWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isGenerating = useState(false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('乱数生成アプリ'),
        actions: [
          HomeContextMenuButton(
            onTappedIgnoreNumber: () {
              context.push(
                RouterInfo.ignoreNumbers.path,
              );
            },
            onTappedCurrentStatus: () {
              context.push(
                RouterInfo.currentStatus.path,
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            _Content(
              onGenerating: () {
                isGenerating.value = true;
              },
              onCompleted: () {
                isGenerating.value = false;
              },
            ),
            if (isGenerating.value) ...[
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Content extends HookConsumerWidget {
  const _Content({
    required this.onGenerating,
    required this.onCompleted,
  });

  final VoidCallback onGenerating;
  final VoidCallback onCompleted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startNumberController = useTextEditingController();
    final endNumberController = useTextEditingController();
    final vm = ref.read(homeScreenViewModelProvider.notifier);
    final randomNumber = useState<RandomNumber?>(null);
    final resultNumber = useState(0);

    Future<void> fetch() async {
      randomNumber.value = await vm.fetchRandomNumber();
      startNumberController.text =
          randomNumber.value?.start.toString() ?? Consts.start.toString();
      endNumberController.text =
          randomNumber.value?.end.toString() ?? Consts.end.toString();
    }

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.microtask(() async {
          await fetch();
        });
      });
      return null;
    }, const []);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          resultNumber.value.toString(),
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const Gap(150),
        SizedBox(
          width: 600,
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 100,
                child: TextField(
                  controller: startNumberController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '開始値',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) async {
                    if (value.isEmpty) {
                      return;
                    }
                    final current = int.parse(value);
                    if (current < 1) {
                      context.showSnackBar('1以上の数字を入力してください');
                    }
                    await vm.changeStartNumber(current);
                    await fetch();
                  },
                ),
              ),
              const Gap(10),
              const Text('から'),
              const Gap(10),
              SizedBox(
                width: 100,
                child: TextField(
                  controller: endNumberController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '終了値',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) async {
                    if (value.isEmpty) {
                      return;
                    }
                    final current = int.parse(value);
                    if (current < 1) {
                      context.showSnackBar('1以上の数字を入力してください');
                    }
                    await vm.changeEndNumber(current);
                    await fetch();
                  },
                ),
              ),
            ],
          ),
        ),
        const Gap(50),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                await vm.cleanCache();
                if (context.mounted) {
                  context.showSnackBar('全てのデータを削除しました。');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                minimumSize: const Size(
                  150,
                  50,
                ),
              ),
              child: const Text(
                '全てのデータを削除',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                onGenerating();
                try {
                  final start = randomNumber.value?.start ?? Consts.start;
                  final end = randomNumber.value?.end ?? Consts.end;
                  final generatedNumber = await vm.generateRandomNumber(
                    start,
                    end,
                  );

                  if (generatedNumber == null) {
                    if (context.mounted) {
                      context.showSnackBar('上限に達しました。一度データを削除してください。');
                    }
                  } else {
                    resultNumber.value = generatedNumber;
                  }
                } catch (e) {
                  if (context.mounted) {
                    context.showSnackBar('数値の範囲が不正です。');
                  }
                }
                onCompleted();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(
                  150,
                  50,
                ),
              ),
              child: const Text(
                '生成',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
