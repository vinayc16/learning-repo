import 'package:flutter/material.dart';

class ShorebirdScreen extends StatefulWidget {
  const ShorebirdScreen({super.key});

  @override
  State<ShorebirdScreen> createState() => _ShorebirdScreenState();
}

class _ShorebirdScreenState extends State<ShorebirdScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Text('ShoreBird'),
    );
  }
}
