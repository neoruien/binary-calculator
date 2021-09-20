import 'package:flutter/material.dart';
import 'package:binary_calculator/components/calcButton.dart';

class CalcRow extends StatelessWidget {
  final List<CalcButton> buttons;

  const CalcRow({
    Key? key,
    required this.buttons,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          for (var button in buttons) button
        ],
      ),
    );
  }
}