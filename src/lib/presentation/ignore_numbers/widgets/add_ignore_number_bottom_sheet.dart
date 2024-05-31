import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:src/extenstion/context_extenstion.dart';

class AddIgnoreNumberBottomSheet extends HookWidget {
  const AddIgnoreNumberBottomSheet({
    super.key,
    required this.onAddIgnoreNumber,
  });

  final void Function(int) onAddIgnoreNumber;

  @override
  Widget build(BuildContext context) {
    final number = useState(1);
    return Container(
      height: 400,
      width: double.infinity,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Gap(26),
          SizedBox(
            width: 200,
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: '非表示番号',
              ),
              keyboardType: TextInputType.number,
              onChanged: (newValue) {
                if (newValue.isEmpty) {
                  return;
                }
                final current = int.parse(newValue);
                if (current < 1) {
                  context.showSnackBar('1以上の数字を入力してください');
                  number.value = 1;
                }
                number.value = current;
              },
            ),
          ),
          const Gap(26),
          ElevatedButton(
            onPressed: () {
              try {
                onAddIgnoreNumber(number.value);
                Navigator.of(context).pop();
              } catch (e) {
                context.showSnackBar('数字を入力してください');
                return;
              }
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(
                150,
                50,
              ),
            ),
            child: const Text('追加'),
          ),
        ],
      ),
    );
  }
}
