import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:src/presentation/ignore_numbers/ignore_numbers_view_model.dart';
import 'package:src/presentation/ignore_numbers/widgets/add_ignore_number_bottom_sheet.dart';

class IgnoreNumbersScreen extends HookConsumerWidget {
  const IgnoreNumbersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ignoreNumberList = useState(<int>[]);
    final isFetching = useState(false);

    Future<void> fetchIgnoreNumberList() async {
      isFetching.value = true;
      ignoreNumberList.value.clear();
      final viewModel = ref.read(ignoreNumbersViewModelProvider.notifier);
      final newIgnoreNumberList = await viewModel.fetchIgnoreNumberList();
      ignoreNumberList.value = newIgnoreNumberList;
      isFetching.value = false;
    }

    useEffect(() {
      Future.microtask(
        () async {
          await fetchIgnoreNumberList();
        },
      );
      return null;
    }, const []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('非表示番号一覧'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchIgnoreNumberList,
          ),
          IconButton(
            onPressed: () async {
              await showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return AddIgnoreNumberBottomSheet(
                      onAddIgnoreNumber: (newValue) async {
                        final viewModel =
                            ref.read(ignoreNumbersViewModelProvider.notifier);
                        await viewModel.addIgnoreNumber(newValue);
                        await fetchIgnoreNumberList();
                      },
                    );
                  });
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              const Gap(kToolbarHeight),
              ignoreNumberList.value.isNotEmpty
                  ? _Content(
                      ignoreNumberList: ignoreNumberList,
                      onRemoved: (value) async {
                        final viewModel =
                            ref.read(ignoreNumbersViewModelProvider.notifier);
                        await viewModel.removeIgnoreNumber(value);
                        await fetchIgnoreNumberList();
                      },
                    )
                  : const Center(
                      child: Text('非表示番号はありません。'),
                    ),
              const Gap(20),
            ],
          ),
          if (isFetching.value) ...[
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
    required this.ignoreNumberList,
    required this.onRemoved,
  });

  final ValueNotifier<List<int>> ignoreNumberList;
  final void Function(int) onRemoved;

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
        itemCount: ignoreNumberList.value.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final ignoreNumber = ignoreNumberList.value[index];
          return ListTile(
              title: Text(ignoreNumber.toString()),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  onRemoved(ignoreNumber);
                },
              ));
        },
      ),
    );
  }
}
