import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  void showSnackBar(
    String text, {
    Duration duration = const Duration(milliseconds: 1500),
    VoidCallback? onTap,
    String closeLabel = '閉じる',
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        backgroundColor: Colors.grey[300]!,
        content: Text(
          text,
          style: Theme.of(this).textTheme.bodyMedium!.copyWith(
                color: Colors.black,
                fontSize: 12,
              ),
        ),
        duration: duration,
        action: SnackBarAction(
          label: closeLabel,
          textColor: Colors.black,
          onPressed: () {
            if (onTap != null) {
              onTap();
            }
          },
        ),
      ),
    );
  }
}
