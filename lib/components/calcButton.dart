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
    return Container(
      margin: EdgeInsets.all(5),
      child: SizedBox(
        width: 55,
        height: 55,
        child: FlatButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          onPressed: condition ? () => callback(text) : null,
          disabledColor: Colors.grey,
          disabledTextColor: Colors.white,
          child: Text(
            text,
            style: GoogleFonts.rubik(
              textStyle: TextStyle(
                fontSize: textSize,
              ),
            ),
          ),
          color: Color(fillColor),
          textColor: Color(textColor),
        ),
      ),
    );
  }
}