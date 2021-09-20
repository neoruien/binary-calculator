import 'package:flutter/material.dart';
import 'package:binary_calculator/util/themeColors.dart' as ThemeColors;
import 'package:binary_calculator/components/calcButton.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((value) => runApp(CalcApp()));
}

class CalcApp extends StatefulWidget {
  @override
  _CalcAppState createState() => _CalcAppState();
}

class _CalcAppState extends State<CalcApp> {
  List<dynamic> _exp = [];
  String _answer = '';
  int _radix = 10;

  void changeMode(String text) {
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
    return !isBinaryMathOperator(text) && !isBinaryBitwiseOperator(text);
  }

  bool isBinaryMathOperator(String text) {
    return text == "+" || text == "-" || text == "*" || text == "//";
  }

  bool isBinaryBitwiseOperator(String text) {
    return text == "and" || text == "or" || text == "xor";
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

  void enterUnaryOperator(String text) {
    if (_exp.length > 0 && isNumeric(_exp.last)) {
      setState(() {
        if (_answer.length > 0) {
          _exp.clear();
          _exp.add(applyUnaryOperator(_answer, text));
          _answer = '';
        } else if (_exp.length > 0) {
          _exp.last = applyUnaryOperator(_exp.last, text);
        }
      });
    }
    debugPrint('$_exp');
  }

  String applyUnaryOperator(String text, String operator) {
    if (operator == 'not' && text.contains('~')) {
        return text.replaceAll("~", "");
    } else if (operator == 'not' && !text.contains('~')) {
        return '~' + text;
    } else if (operator == '±' && text.contains('-')) {
        return text.replaceAll("-", "");
    } else if (operator == '±' && !text.contains('-')) {
        return '-' + text;
    } else {
      throw("Error");
    }
  }

  void enterBinaryOperator(String text) {
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
        if (_exp.last.length == 1 || isBinaryBitwiseOperator(_exp.last)) {
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
      if (isNumeric(_dec[i])) {
        String target = _dec[i];
        String targetTrimmed = target.replaceAll("~", "").replaceAll("-", "");

        int negateIndex = target.indexOf("-");
        int notIndex = target.indexOf("~");
        print("isNegated: " + target.indexOf("-").toString());
        print("isNoted: " + target.indexOf("~").toString());

        int targetNum = int.parse(targetTrimmed.toString(), radix: _radix);

        if (negateIndex == 0 && notIndex == 1) {
          targetNum = -(~targetNum);
        } else if (negateIndex == 1 && notIndex == 0) {
          targetNum = ~(-targetNum);
        } else if (negateIndex == 0) {
          targetNum = -targetNum;
        } else if (notIndex == 0) {
          targetNum = ~targetNum;
        }

        _dec[i] = targetNum;
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
      } else if (_dec[i] == "//") {
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
    print("processed: " + _processed.toString());
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
    print("ans: " + ans.toString());
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
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Color(ThemeColors.WHITE),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.all(10),
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
                            color: Color(ThemeColors.BLACK),
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
                            color: Color(ThemeColors.BLACK),
                          ),
                        ),
                      ),
                    ),
                    alignment: Alignment(1.0, 1.0),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(ThemeColors.GRADIENT_COLOR),
                          Color(ThemeColors.WHITE),
                        ],
                      )
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            CalcButton(
                              text: 'hex',
                              textSize: 18,
                              textColor: _radix == 16 ? ThemeColors.PRIMARY : ThemeColors.INACTIVE_COLOR,
                              method: changeMode,
                            ),
                            CalcButton(
                              text: 'dec',
                              textSize: 18,
                              textColor: _radix == 10 ? ThemeColors.PRIMARY : ThemeColors.INACTIVE_COLOR,
                              method: changeMode,
                            ),
                            CalcButton(
                              text: 'oct',
                              textSize: 18,
                              textColor: _radix == 8 ? ThemeColors.PRIMARY : ThemeColors.INACTIVE_COLOR,
                              method: changeMode,
                            ),
                            CalcButton(
                              text: 'bin',
                              textSize: 18,
                              textColor: _radix == 2 ? ThemeColors.PRIMARY : ThemeColors.INACTIVE_COLOR,
                              method: changeMode,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            CalcButton(
                              text: 'and',
                              textSize: 18,
                              textColor: ThemeColors.PRIMARY,
                              method: enterBinaryOperator,
                            ),
                            CalcButton(
                              text: 'or',
                              textSize: 18,
                              textColor: ThemeColors.PRIMARY,
                              method: enterBinaryOperator,
                            ),
                            CalcButton(
                              text: 'xor',
                              textSize: 18,
                              textColor: ThemeColors.PRIMARY,
                              method: enterBinaryOperator,
                            ),
                            CalcButton(
                              text: 'not',
                              textSize: 18,
                              textColor: ThemeColors.PRIMARY,
                              method: enterUnaryOperator,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            CalcButton(
                              text: 'A',
                              condition: _radix == 16,
                              method: enterNumber,
                            ),
                            CalcButton(
                              text: 'B',
                              condition: _radix == 16,
                              method: enterNumber,
                            ),
                            CalcButton(
                              text: 'C',
                              condition: _radix == 16,
                              method: enterNumber,
                            ),
                            CalcButton(
                              text: '±',
                              textColor: ThemeColors.PRIMARY,
                              method: enterUnaryOperator,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            CalcButton(
                              text: 'D',
                              condition: _radix == 16,
                              method: enterNumber,
                            ),
                            CalcButton(
                              text: 'E',
                              condition: _radix == 16,
                              method: enterNumber,
                            ),
                            CalcButton(
                              text: 'F',
                              condition: _radix == 16,
                              method: enterNumber,
                            ),
                            CalcButton(
                              text: '//',
                              textColor: ThemeColors.PRIMARY,
                              method: enterBinaryOperator,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            CalcButton(
                              text: '7',
                              condition: _radix >= 8,
                              method: enterNumber,
                            ),
                            CalcButton(
                              text: '8',
                              condition: _radix >= 10,
                              method: enterNumber,
                            ),
                            CalcButton(
                              text: '9',
                              condition: _radix >= 10,
                              method: enterNumber,
                            ),
                            CalcButton(
                              text: '*',
                              textColor: ThemeColors.PRIMARY,
                              method: enterBinaryOperator,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            CalcButton(
                              text: '4',
                              condition: _radix >= 8,
                              method: enterNumber,
                            ),
                            CalcButton(
                              text: '5',
                              condition: _radix >= 8,
                              method: enterNumber,
                            ),
                            CalcButton(
                              text: '6',
                              condition: _radix >= 8,
                              method: enterNumber,
                            ),
                            CalcButton(
                              text: '-',
                              textColor: ThemeColors.PRIMARY,
                              method: enterBinaryOperator,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            CalcButton(
                              text: '1',
                              method: enterNumber,
                            ),
                            CalcButton(
                              text: '2',
                              condition: _radix >= 8,
                              method: enterNumber,
                            ),
                            CalcButton(
                              text: '3',
                              condition: _radix >= 8,
                              method: enterNumber,
                            ),
                            CalcButton(
                              text: '+',
                              textColor: ThemeColors.PRIMARY,
                              method: enterBinaryOperator,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            CalcButton(
                              text: '0',
                              method: enterNumber,
                            ),
                            CalcButton(
                              text: 'AC',
                              method: clear,
                            ),
                            CalcButton(
                              text: '⌫',
                              method: delete,
                            ),
                            CalcButton(
                              text: '=',
                              textColor: ThemeColors.PRIMARY,
                              method: evaluate,
                            ),
                          ],
                        )
                      ])
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}