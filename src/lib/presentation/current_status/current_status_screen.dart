import 'package:flutter/material.dart';

class CurrentStatusScreen extends StatelessWidget {
  const CurrentStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Current Status'),
      ),
      body: Center(
        child: Text('Current Status Screen'),
      ),
    );
  }
}