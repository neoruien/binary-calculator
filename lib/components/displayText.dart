import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:binary_calculator/util/themeColors.dart' as ThemeColors;
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';

class DisplayText extends StatelessWidget {
  final String text;
  final int textColor;
  final double textSize;

  final _scrollController = ScrollController();

  DisplayText({
    Key? key,
    required this.text,
    this.textColor = ThemeColors.BLACK,
    this.textSize = 25,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FadingEdgeScrollView.fromSingleChildScrollView(
        gradientFractionOnStart: 0.3,
        gradientFractionOnEnd: 0.3,
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
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
      ),
    );
  }
}