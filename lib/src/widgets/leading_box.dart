import 'package:flutter/material.dart';

class LeadingBox extends StatelessWidget {
  final Color color;
  final String letter;

  const LeadingBox({Key? key, required this.color, required this.letter}) : super(key: key);

  static const _textStyle = TextStyle(
    fontSize: 16,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      color: color,
      child: Text(letter, style: _textStyle),
    );
  }
}