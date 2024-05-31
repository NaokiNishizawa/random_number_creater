import 'package:flutter/material.dart';

class HomeContextMenuButton extends StatelessWidget {
  const HomeContextMenuButton({
    super.key,
    required this.onTappedIgnoreNumber,
    required this.onTappedCurrentStatus,
  });

  final VoidCallback onTappedIgnoreNumber;
  final VoidCallback onTappedCurrentStatus;

  static const double _kPopupMenuItemHeight = 44.0;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      icon: const Icon(
        Icons.list,
      ),
      iconSize: 24,
      offset: const Offset(0, 40),
      itemBuilder: (context) {
        return <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            height: _kPopupMenuItemHeight,
            onTap: onTappedIgnoreNumber,
            child: const Text(
              '非表示番号',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
          const PopupMenuDivider(),
          PopupMenuItem<String>(
            height: _kPopupMenuItemHeight,
            onTap: onTappedCurrentStatus,
            child: const Text(
              '現状',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        ];
      },
    );
  }
}
