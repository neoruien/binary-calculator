import 'package:flutter/material.dart';
import 'package:binary_calculator/util/constants.dart' as Constants;
import 'package:binary_calculator/components/calcButton.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(CalcApp());
}

class CalcApp extends StatefulWidget {
  @override
  _CalcAppState createState() => _CalcAppState();
}

enum Mode {
  hex, dec, oct, bin
}

class _CalcAppState extends State<CalcApp> {
  List<String> _expression = [];
  String _answer = '';
  Mode mode = Mode.dec;

  final numberCheck = RegExp(r'[A-F0-9]');

  bool isLastInputNumeric() {
    debugPrint(_expression.last + ": " + numberCheck.hasMatch(_expression.last).toString());
    return numberCheck.hasMatch(_expression.last);
  }

  void test(String text) {}

  void enterNumber(String text) {
    setState(() {
      if (_expression.length == 0 || !isLastInputNumeric()) {
        _expression.add(text);
      } else {
        _expression.last += text;
      }
    });
    debugPrint('$_expression');
  }

  void selectOperator(String text) {
    setState(() {
      if (isLastInputNumeric()) {
        _expression.add(text);
      } else {
        _expression.last = text;
      }
    });
    debugPrint('$_expression');
  }

  void clear(String text) {
    setState(() {
      _answer = '';
      _expression.clear();
    });
  }

  void delete(String text) {
    if (_expression.length > 0) {
      setState(() {
        if (_expression.last.length == 1) {
          _expression.removeLast();
        } else {
          _expression.last = _expression.last.substring(0, _expression.last.length - 1);
        }
      });
    }
    debugPrint('$_expression');
  }

  void evaluate(String text) {
    if (!isLastInputNumeric()) {
      setState(() {
        _expression.removeLast();
      });
    }
    debugPrint('$_expression');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      home: Scaffold(
        backgroundColor: Color(Constants.BACKGROUND_COLOR),
        body: Container(
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Text(
                      _answer,
                      style: GoogleFonts.rubik(
                        textStyle: TextStyle(
                          fontSize: 24,
                          color: Color(0xFF545F61),
                        ),
                      ),
                    ),
                  ),
                  alignment: Alignment(1.0, 1.0),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      _expression.join(" "),
                      style: GoogleFonts.rubik(
                        textStyle: TextStyle(
                          fontSize: 48,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  alignment: Alignment(1.0, 1.0),
                ),
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CalcButton(
                    text: 'A',
                    callback: test,
                  ),
                  CalcButton(
                    text: 'B',
                    callback: enterNumber,
                  ),
                  CalcButton(
                    text: 'C',
                    callback: enterNumber,
                  ),
                  CalcButton(
                    text: '±',
                    fillColor: Constants.SECONDARY_COLOR,
                    callback: selectOperator,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CalcButton(
                    text: 'D',
                    callback: enterNumber,
                  ),
                  CalcButton(
                    text: 'E',
                    callback: enterNumber,
                  ),
                  CalcButton(
                    text: 'F',
                    callback: enterNumber,
                  ),
                  CalcButton(
                    text: '/',
                    fillColor: Constants.SECONDARY_COLOR,
                    callback: selectOperator,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CalcButton(
                    text: '7',
                    callback: enterNumber,
                  ),
                  CalcButton(
                    text: '8',
                    callback: enterNumber,
                  ),
                  CalcButton(
                    text: '9',
                    callback: enterNumber,
                  ),
                  CalcButton(
                    text: '*',
                    fillColor: Constants.SECONDARY_COLOR,
                    callback: selectOperator,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CalcButton(
                    text: '4',
                    callback: enterNumber,
                  ),
                  CalcButton(
                    text: '5',
                    callback: enterNumber,
                  ),
                  CalcButton(
                    text: '6',
                    callback: enterNumber,
                  ),
                  CalcButton(
                    text: '-',
                    fillColor: Constants.SECONDARY_COLOR,
                    callback: selectOperator,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CalcButton(
                    text: '1',
                    callback: enterNumber,
                  ),
                  CalcButton(
                    text: '2',
                    callback: enterNumber,
                  ),
                  CalcButton(
                    text: '3',
                    callback: enterNumber,
                  ),
                  CalcButton(
                    text: '+',
                    fillColor: Constants.SECONDARY_COLOR,
                    callback: selectOperator,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CalcButton(
                    text: '0',
                    callback: enterNumber,
                  ),
                  CalcButton(
                    text: 'C',
                    callback: clear,
                  ),
                  CalcButton(
                    text: '<-',
                    callback: delete,
                  ),
                  CalcButton(
                    text: '=',
                    fillColor: Constants.PRIMARY_COLOR,
                    callback: evaluate,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}