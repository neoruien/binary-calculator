import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:binary_calculator/util/themeColors.dart' as ThemeColors;

class DisplayText extends StatelessWidget {
  final String text;
  final int textColor;
  final double textSize;

  const DisplayText({
    Key? key,
    required this.text,
    this.textColor = ThemeColors.BLACK,
    this.textSize = 25,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Text(
            text,
            style: GoogleFonts.rubik(
              textStyle: TextStyle(
                fontSize: textSize,
                color: Color(textColor),
              ),
            ),
          ),
        ),
        alignment: Alignment(1.0, 1.0),
      ),
    );
  }
}