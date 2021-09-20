import 'package:binary_calculator/components/calcRow.dart';
import 'package:binary_calculator/components/displayText.dart';
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
  List<dynamic> _expressions = [];
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
      // update expressions
      for (int i=0; i<_expressions.length; i++) {
        if (isNumeric(_expressions[i])) {
          _expressions[i] = int.parse(_expressions[i], radix: originalRadix).toRadixString(_radix).toUpperCase();
        }
      }
      // update ans
      if (_answer != "") {
        _answer = int.parse(_answer, radix: originalRadix).toRadixString(_radix).toUpperCase();
      }
    });
    debugPrint('$_expressions');
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
      _expressions.clear();
    }
    setState(() {
      if (_expressions.length == 0 || !isNumeric(_expressions.last)) {
        _expressions.add(text);
      } else {
        _expressions.last += text;
      }
    });
    debugPrint('$_expressions');
  }

  void enterUnaryOperator(String text) {
    if (_expressions.length > 0 && isNumeric(_expressions.last)) {
      setState(() {
        if (_answer.length > 0) {
          _expressions.clear();
          _expressions.add(applyUnaryOperator(_answer, text));
          _answer = '';
        } else if (_expressions.length > 0) {
          _expressions.last = applyUnaryOperator(_expressions.last, text);
        }
      });
    }
    debugPrint('$_expressions');
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
      _expressions.clear();
      _expressions.add(_answer);
      _answer = '';
    } else if (_expressions.length == 0) {
      return;
    }
    setState(() {
      if (isNumeric(_expressions.last)) {
        _expressions.add(text);
      } else {
        _expressions.last = text;
      }
    });
    debugPrint('$_expressions');
  }

  void clear(String text) {
    setState(() {
      _answer = '';
      _expressions.clear();
    });
  }

  void delete(String text) {
    if (_expressions.length > 0) {
      setState(() {
        if (_expressions.last.length == 1 || isBinaryBitwiseOperator(_expressions.last)) {
          _expressions.removeLast();
        } else {
          _expressions.last = _expressions.last.substring(0, _expressions.last.length - 1);
        }
      });
    }
    debugPrint('$_expressions');
  }

  void evaluate(String text) {
    if (!isNumeric(_expressions.last)) {
      setState(() {
        _expressions.removeLast();
      });
    }

    List<dynamic> _dec = [..._expressions];
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
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: Color(ThemeColors.WHITE),
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(50),
              child: AppBar(
                backgroundColor: Color(ThemeColors.WHITE),
                elevation: 0,
                bottom: TabBar(
                  indicatorColor: Color(ThemeColors.PRIMARY),
                  labelColor: Color(ThemeColors.PRIMARY),
                  unselectedLabelColor: Color(ThemeColors.GREY),
                  tabs: [
                    Tab(icon: Text(
                        "Calculator",
                        style: GoogleFonts.rubik(
                          textStyle: TextStyle(fontSize: 18)
                        )
                    )),
                    Tab(icon: Text(
                        "History",
                        style: GoogleFonts.rubik(
                            textStyle: TextStyle(fontSize: 18)
                        )
                    )),
                  ],
                ),
              ),
            ),
            body: TabBarView(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            DisplayText(text: _expressions.join(" "), textSize: 24,),
                            DisplayText(text: _answer, textSize: 48,),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CalcRow(buttons: [
                              CalcButton(
                                text: 'hex',
                                textSize: 18,
                                textColor: _radix == 16 ? ThemeColors.PRIMARY : ThemeColors.GREY,
                                method: changeMode,
                              ),
                              CalcButton(
                                text: 'dec',
                                textSize: 18,
                                textColor: _radix == 10 ? ThemeColors.PRIMARY : ThemeColors.GREY,
                                method: changeMode,
                              ),
                              CalcButton(
                                text: 'oct',
                                textSize: 18,
                                textColor: _radix == 8 ? ThemeColors.PRIMARY : ThemeColors.GREY,
                                method: changeMode,
                              ),
                              CalcButton(
                                text: 'bin',
                                textSize: 18,
                                textColor: _radix == 2 ? ThemeColors.PRIMARY : ThemeColors.GREY,
                                method: changeMode,
                              ),
                            ]),
                            CalcRow(buttons: [
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
                            ]),
                            CalcRow(buttons: [
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
                            ]),
                            CalcRow(buttons: [
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
                            ]),
                            CalcRow(buttons: [
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
                            ]),
                            CalcRow(buttons: [
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
                            ]),
                            CalcRow(buttons: [
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
                            ]),
                            CalcRow(buttons: [
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
                            ])
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text("1")
                  ],
                )
              ],
            )
          ),
        ),
      ),
    );
  }
}