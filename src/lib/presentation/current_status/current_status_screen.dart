import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:src/presentation/current_status/current_status_view_model.dart';

class CurrentStatusScreen extends HookConsumerWidget {
  const CurrentStatusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoaded = useState(false);
    final vm = ref.read(currentStatusViewModelProvider.notifier);
    final appearedNumberList = useState(<int>[]);

    Future<void> fetch() async {
      isLoaded.value = true;
      final currentNumberList = await vm.fetch();
      appearedNumberList.value = currentNumberList;
      // 中身を昇順にソートする
      appearedNumberList.value.sort();
      isLoaded.value = false;
    }

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.microtask(() async {
          await fetch();
        });
      });
      return;
    }, const []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('現在の状況'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          _Content(
            appearedNumberList: appearedNumberList,
          ),
          if (isLoaded.value) ...[
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    required this.appearedNumberList,
  });

  final ValueNotifier<List<int>> appearedNumberList;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        0,
        20,
        0,
      ),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: appearedNumberList.value.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final number = appearedNumberList.value[index];
          return ListTile(
            title: Text(number.toString()),
          );
        },
      ),
    );
  }
}
