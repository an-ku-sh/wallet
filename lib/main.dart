import 'package:flutter/material.dart';
import 'package:wallet/Pages/home.dart';

void main() {
  runApp(const MaterialAppBase());
}

class MaterialAppBase extends StatelessWidget {
  const MaterialAppBase({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}
