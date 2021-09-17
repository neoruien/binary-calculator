import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CalcButton extends StatelessWidget {
  final String text;
  final int fillColor;
  final int textColor;
  final double textSize;
  final bool condition;
  final Function callback;

  const CalcButton({
    Key? key,
    required this.text,
    this.fillColor = 0x00,
    this.textColor = 0xFFFFFFFF,
    this.textSize = 25,
    this.condition = true,
    required this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      primary: Colors.white,
      backgroundColor: Color(fillColor),
      onSurface: Colors.grey,
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

    return Container(
      margin: EdgeInsets.all(5),
      child: SizedBox(
        width: 55,
        height: 55,
        child: TextButton(
          style: flatButtonStyle,
          onPressed: condition ? () => callback(text) : null,
          child: buttonText
        )
      ),
    );
  }
}