import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:src/extenstion/context_extenstion.dart';

class AddIgnoreNumberBottomSheet extends StatelessWidget {
  const AddIgnoreNumberBottomSheet({
    super.key,
    required this.onAddIgnoreNumber,
  });

  final void Function(int) onAddIgnoreNumber;

  @override
  Widget build(BuildContext context) {
    final numberController = TextEditingController(text: '1');
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
              controller: numberController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: '非表示番号',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                if (value.isEmpty) {
                  return;
                }
                final current = int.parse(value);
                if (current < 1) {
                  context.showSnackBar('1以上の数字を入力してください');
                  numberController.text = '1';
                }
                numberController.text = value;
              },
            ),
          ),
          const Gap(26),
          ElevatedButton(
            onPressed: () {
              try {
                final current = int.parse(numberController.text);
                onAddIgnoreNumber(current);
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
