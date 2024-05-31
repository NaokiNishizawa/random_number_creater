import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:src/presentation/home/home_screen_view_model.dart';

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
    final startNumberController = TextEditingController(text: '1');
    final endNumberController = TextEditingController(text: '21');
    final vm = ref.read(homeScreenViewModelProvider.notifier);
    final number = useState(0);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          number.value.toString(),
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
              onPressed: () {
                // TODO: すべてのデータを削除処理
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
                  final start = int.parse(startNumberController.text);
                  final end = int.parse(endNumberController.text);
                  final generatedNumber = await vm.generateRandomNumber(
                    start,
                    end,
                  );

                  if (generatedNumber == null) {
                    // TODO: エラーの表示
                  } else {
                    number.value = generatedNumber;
                  }
                } catch (e) {
                  // nothing to do
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
