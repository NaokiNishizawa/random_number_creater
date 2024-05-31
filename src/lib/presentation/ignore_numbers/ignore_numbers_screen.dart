import 'package:flutter/material.dart';

class IgnoreNumbersScreen extends StatelessWidget {
  const IgnoreNumbersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ignore Numbers'),
      ),
      body: Center(
        child: Text('Ignore Numbers Screen'),
      ),
    );
  }
}