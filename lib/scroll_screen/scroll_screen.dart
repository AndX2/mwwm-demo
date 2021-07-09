import 'package:flutter/material.dart';

class ScrollScreen extends StatefulWidget {
  ScrollScreen({Key? key}) : super(key: key);

  @override
  _ScrollScreenState createState() => _ScrollScreenState();
}

class _ScrollScreenState extends State<ScrollScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scroll screen')),
    );
  }
}
