import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:binary_calculator/util/themeColors.dart' as ThemeColors;

class CalcButton extends StatelessWidget {
  final String text;
  final int textColor;
  final double textSize;
  final bool condition;
  final Function method;

  const CalcButton({
    Key? key,
    required this.text,
    this.textColor = ThemeColors.BLACK,
    this.textSize = 25,
    this.condition = true,
    required this.method,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      primary: Color(textColor),
      onSurface: Color(ThemeColors.GREY),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50.0),
      ),
    );

    final Text buttonText = Text(
      text,
      style: GoogleFonts.rubik(
        textStyle: TextStyle(
          fontSize: textSize,
        ),
      ),
    );

    return Expanded(
        child: TextButton(
          style: flatButtonStyle,
          onPressed: condition ? () => method(text) : null,
          child: buttonText
        )
    );
  }
}