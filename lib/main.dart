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

class _CalcAppState extends State<CalcApp> {
  List<String> _exp = [];
  String _answer = '';

  final numberCheck = RegExp(r'[A-F0-9]');

  bool isLastInputNumeric() {
    // debugPrint(_exp.last + ": " + numberCheck.hasMatch(_exp.last).toString());
    return numberCheck.hasMatch(_exp.last);
  }

  void test(String text) {}

  void enterNumber(String text) {
    setState(() {
      if (_exp.length == 0 || !isLastInputNumeric()) {
        _exp.add(text);
      } else {
        _exp.last += text;
      }
    });
    debugPrint('$_exp');
  }

  void selectOperator(String text) {
    setState(() {
      if (isLastInputNumeric()) {
        _exp.add(text);
      } else {
        _exp.last = text;
      }
    });
    debugPrint('$_exp');
  }

  void clear(String text) {
    setState(() {
      _answer = '';
      _exp.clear();
    });
  }

  void delete(String text) {
    if (_exp.length > 0) {
      setState(() {
        if (_exp.last.length == 1) {
          _exp.removeLast();
        } else {
          _exp.last = _exp.last.substring(0, _exp.last.length - 1);
        }
      });
    }
    debugPrint('$_exp');
  }

  void evaluate(String text) {
    if (!isLastInputNumeric()) {
      setState(() {
        _exp.removeLast();
      });
    }
    debugPrint('$_exp');

    // First loop: init
    List<String> _processed = [];
    _processed.add(_exp[0]);
    // First loop: loop
    int i = 1;
    while (i < _exp.length) {
      if (_exp[i] == "*") {
        _processed.last = (double.parse(_processed.last) * double.parse(_exp[i+1])).toString();
      } else if (_exp[i] == "/") {
        _processed.last = (double.parse(_processed.last) / double.parse(_exp[i+1])).toString();
      } else {
        _processed.add(_exp[i]);
        _processed.add(_exp[i+1]);
      }
      i += 2;
    }
    // First loop: debug
    print("processed:");
    print(_processed);
    // Second loop: init
    double ans = double.parse(_processed[0]);
    // Second loop: loop
    int j = 1;
    while (j < _processed.length) {
      if (_processed[j] == "+") {
        ans = ans + double.parse(_processed[j + 1]);
      } else if (_processed[j] == "-") {
        ans = ans - double.parse(_processed[j + 1]);
      }
      j += 2;
    }
    // Second loop: debug
    print("ans:");
    print(ans);
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
                      _exp.join(" "),
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