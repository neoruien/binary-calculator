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
  List<dynamic> _exp = [];
  String _answer = '';
  int _radix = 10;

  void changeRadix(String text) {
    int originalRadix = _radix;
    setState(() {
      // change radix
      if (text == "hex") {
        _radix = 16;
      } else if (text == "dec") {
        _radix = 10;
      } else if (text == "oct") {
        _radix = 8;
      } else if (text == "bin") {
        _radix = 2;
      }
      // update exp
      for (int i=0; i<_exp.length; i++) {
        if (isNumeric(_exp[i])) {
          _exp[i] = int.parse(_exp[i], radix: originalRadix).toRadixString(_radix).toUpperCase();
        }
      }
      // update ans
      if (_answer != "") {
        _answer = int.parse(_answer, radix: originalRadix).toRadixString(_radix).toUpperCase();
      }
    });
    debugPrint('$_exp');
  }

  bool isNumeric(String text) {
    return "+-*/".contains(text) == false && text != "and" && text != "or" && text != "xor";
  }

  bool isBinaryOperator(String text) {
    return text == "+" || text == "-" || text == "*" || text == "//" ||  text == "and" || text == "or" || text == "xor";
  }

  bool isUnaryOperator(String text) {
    return text == "±" || text == "not";
  }

  bool isFloat(String text) {
    return text.contains(".");
  }

  void enterNumber(String text) {
    if (_answer.length > 0) {
      _answer = '';
      _exp.clear();
    }
    setState(() {
      if (_exp.length == 0 || !isNumeric(_exp.last)) {
        _exp.add(text);
      } else {
        _exp.last += text;
      }
    });
    debugPrint('$_exp');
  }

  void enterNotSign(String text) {
    setState(() {
      if (_answer.length > 0) {
        _exp.clear();
        _exp.add(not(_answer));
        _answer = '';
      } else if (_exp.length > 0) {
        _exp.last = not(_exp.last);
      }
    });
  }

  void enterPlusMinusSign(String text) {
    setState(() {
      if (_answer.length > 0) {
        _exp.clear();
        _exp.add(negate(_answer));
        _answer = '';
      } else if (_exp.length > 0) {
        _exp.last = negate(_exp.last);
      }
    });
  }

  String not(String text) {
    if (text.startsWith('not')) {
      return text.split("(")[1].split(")")[0];
    } else {
      return 'not(' + text + ')';
    }
  }

  String negate(String text) {
    if (text.startsWith('-')) {
      return text.substring(1);
    } else {
      return '-' + text;
    }
  }

  void selectOperator(String text) {
    if (_answer.length > 0) {
      _exp.clear();
      _exp.add(_answer);
      _answer = '';
    } else if (_exp.length == 0) {
      return;
    }
    setState(() {
      if (isNumeric(_exp.last)) {
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
    if (!isNumeric(_exp.last)) {
      setState(() {
        _exp.removeLast();
      });
    }

    List<dynamic> _dec = [..._exp];
    debugPrint('evaluate: $_dec');

    // Convert to dec
    for (int i=0; i<_dec.length; i++) {
      if (_dec[i].startsWith("not")) {
        int targetNum = int.parse(_dec[i].split("(")[1].split(")")[0]);
        _dec[i] = (~targetNum).toString();
      }
      if (isNumeric(_dec[i])) {
        _dec[i] = int.parse(_dec[i], radix: _radix);
      }
    }

    // First loop: init
    List<dynamic> _processed = [];
    _processed.add(_dec[0]);
    // First loop: loop
    int i = 1;
    while (i < _dec.length) {
      if (_dec[i] == "*") {
        _processed.last = _processed.last * _dec[i+1];
      } else if (_dec[i] == "/") {
        _processed.last = _processed.last ~/ _dec[i + 1];
      } else if (_dec[i] == "and") {
        _processed.last = _processed.last & _dec[i + 1];
      } else if (_dec[i] == "or") {
        _processed.last = _processed.last | _dec[i + 1];
      } else if (_dec[i] == "xor") {
        _processed.last = _processed.last ^ _dec[i + 1];
      } else {
        _processed.add(_dec[i]);
        _processed.add(_dec[i+1]);
      }
      i += 2;
    }
    // First loop: debug
    print("processed:");
    print(_processed);
    // Second loop: init
    dynamic ans = _processed[0];
    // Second loop: loop
    int j = 1;
    while (j < _processed.length) {
      if (_processed[j] == "+") {
        ans = ans + _processed[j + 1];
      } else if (_processed[j] == "-") {
        ans = ans - _processed[j + 1];
      }
      j += 2;
    }
    // Second loop: debug
    print("ans:");
    print(ans);
    // Second loop: setState
    setState(() {
      _answer = ans.toRadixString(_radix).toUpperCase();
    });
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
                      _exp.join(" "),
                      style: GoogleFonts.rubik(
                        textStyle: TextStyle(
                          fontSize: 24,
                          color: Color(0xFF545F90),
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
                      _answer,
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
                    text: 'hex',
                    textSize: 18,
                    fillColor: _radix == 16 ? Constants.SECONDARY_COLOR : 0x00,
                    callback: changeRadix,
                  ),
                  CalcButton(
                    text: 'dec',
                    textSize: 18,
                    fillColor: _radix == 10 ? Constants.SECONDARY_COLOR : 0x00,
                    callback: changeRadix,
                  ),
                  CalcButton(
                    text: 'oct',
                    textSize: 18,
                    fillColor: _radix == 8 ? Constants.SECONDARY_COLOR : 0x00,
                    callback: changeRadix,
                  ),
                  CalcButton(
                    text: 'bin',
                    textSize: 18,
                    fillColor: _radix == 2 ? Constants.SECONDARY_COLOR : 0x00,
                    callback: changeRadix,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CalcButton(
                    text: 'and',
                    textSize: 18,
                    fillColor: Constants.SECONDARY_COLOR,
                    callback: selectOperator,
                  ),
                  CalcButton(
                    text: 'or',
                    textSize: 18,
                    fillColor: Constants.SECONDARY_COLOR,
                    callback: selectOperator,
                  ),
                  CalcButton(
                    text: 'xor',
                    textSize: 18,
                    fillColor: Constants.SECONDARY_COLOR,
                    callback: selectOperator,
                  ),
                  CalcButton(
                    text: 'not',
                    textSize: 18,
                    fillColor: Constants.SECONDARY_COLOR,
                    callback: enterNotSign,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CalcButton(
                    text: 'A',
                    fillColor: _radix == 16 ? Constants.SECONDARY_COLOR : 0x00,
                    condition: _radix == 16,
                    callback: enterNumber,
                  ),
                  CalcButton(
                    text: 'B',
                    fillColor: _radix == 16 ? Constants.SECONDARY_COLOR : 0x00,
                    condition: _radix == 16,
                    callback: enterNumber,
                  ),
                  CalcButton(
                    text: 'C',
                    fillColor: _radix == 16 ? Constants.SECONDARY_COLOR : 0x00,
                    condition: _radix == 16,
                    callback: enterNumber,
                  ),
                  CalcButton(
                    text: '±',
                    fillColor: Constants.SECONDARY_COLOR,
                    callback: enterPlusMinusSign,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CalcButton(
                    text: 'D',
                    fillColor: _radix == 16 ? Constants.SECONDARY_COLOR : 0x00,
                    condition: _radix == 16,
                    callback: enterNumber,
                  ),
                  CalcButton(
                    text: 'E',
                    fillColor: _radix == 16 ? Constants.SECONDARY_COLOR : 0x00,
                    condition: _radix == 16,
                    callback: enterNumber,
                  ),
                  CalcButton(
                    text: 'F',
                    fillColor: _radix == 16 ? Constants.SECONDARY_COLOR : 0x00,
                    condition: _radix == 16,
                    callback: enterNumber,
                  ),
                  CalcButton(
                    text: '//',
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
                    fillColor: _radix >= 8 ? Constants.SECONDARY_COLOR : 0x00,
                    condition: _radix >= 8,
                    callback: enterNumber,
                  ),
                  CalcButton(
                    text: '8',
                    fillColor: _radix >= 10 ? Constants.SECONDARY_COLOR : 0x00,
                    condition: _radix >= 10,
                    callback: enterNumber,
                  ),
                  CalcButton(
                    text: '9',
                    fillColor: _radix >= 10 ? Constants.SECONDARY_COLOR : 0x00,
                    condition: _radix >= 10,
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
                    fillColor: _radix >= 8 ? Constants.SECONDARY_COLOR : 0x00,
                    condition: _radix >= 8,
                    callback: enterNumber,
                  ),
                  CalcButton(
                    text: '5',
                    fillColor: _radix >= 8 ? Constants.SECONDARY_COLOR : 0x00,
                    condition: _radix >= 8,
                    callback: enterNumber,
                  ),
                  CalcButton(
                    text: '6',
                    fillColor: _radix >= 8 ? Constants.SECONDARY_COLOR : 0x00,
                    condition: _radix >= 8,
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
                    fillColor: Constants.SECONDARY_COLOR,
                    callback: enterNumber,
                  ),
                  CalcButton(
                    text: '2',
                    fillColor: _radix >= 8 ? Constants.SECONDARY_COLOR : 0x00,
                    condition: _radix >= 8,
                    callback: enterNumber,
                  ),
                  CalcButton(
                    text: '3',
                    fillColor: _radix >= 8 ? Constants.SECONDARY_COLOR : 0x00,
                    condition: _radix >= 8,
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
                    fillColor: Constants.SECONDARY_COLOR,
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