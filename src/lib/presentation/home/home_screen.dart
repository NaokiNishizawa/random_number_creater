import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
            const _Content(),
            if (isGenerating.value) ...[
              Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  )),
            ],
          ],
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({super.key});

  @override
  Widget build(BuildContext context) {
    final startNumberController = TextEditingController();
    final endNumberController = TextEditingController();
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
              TextField(
                controller: startNumberController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '開始値',
                ),
                keyboardType: TextInputType.number,
              ),
              const Gap(10),
              const Text('から'),
              const Gap(10),
              TextField(
                controller: endNumberController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '終了値',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: () {

          },
          child: const Text(
            '生成',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
