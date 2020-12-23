import 'dart:io';

import 'package:budgetour/tools/GlobalValues.dart';
import 'package:common_tools/ColorGenerator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CalculatorView extends StatefulWidget {
  final CalculatorController controller;

  CalculatorView(this.controller);

  @override
  _CalculatorViewState createState() => _CalculatorViewState();
}

class _CalculatorViewState extends State<CalculatorView>
    with TickerProviderStateMixin {
  Color decimalColor;
  Color splashcolor;

  @override
  void initState() {
    widget.controller.attachSplashNotifier((entryPassed) {
      setState(() {
        if (entryPassed)
          splashcolor = Colors.grey;
        else
          splashcolor = Colors.red;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      width: double.infinity,
      color: ColorGenerator.fromHex(GlobalValues.calcBackgroundColor),
      child: Container(
        padding: EdgeInsets.all(4.0),
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: buildNumPad(context),
            ),
            Expanded(
              flex: 1,
              child: buildEnterButton(
                'Enter',
                context,
              ),
            )
          ],
        ),
      ),
    );
  }

  Row buildNumPad(BuildContext context) {
    return Row(
      children: [
        // Plus Minus buttons
        Expanded(
          flex: 1,
          child: Column(
            children: [
              buildButton('+', context),
              buildButton('-', context),
            ],
          ),
        ),

        // Numerical pad
        Expanded(
          flex: 4,
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildButton('1', context),
                    buildButton('2', context),
                    buildButton('3', context),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildButton('4', context),
                    buildButton('5', context),
                    buildButton('6', context),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildButton('7', context),
                    buildButton('8', context),
                    buildButton('9', context),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildButton('.', context, optionalColor: decimalColor,
                        onTap: () {
                      widget.controller.updateValue('.');
                      setState(() {
                        if (widget.controller.decimalInUse)
                          decimalColor = ColorGenerator.fromHex(
                              GlobalValues.calcDisabledButtonColor);
                      });
                    }),
                    buildButton('0', context),
                    buildBackspaceButton('bks', context, onTap: () {}),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildButton(String text, BuildContext ctx,
      {Function onTap, Color optionalColor}) {
    return Expanded(
      flex: 1,
      child: Material(
        color: ColorGenerator.fromHex(GlobalValues.calcBackgroundColor),
        child: InkWell(
          splashColor: splashcolor,
          onTap: onTap ??
              () {
                widget.controller.updateValue(text);
              },
          child: Padding(
            padding: const EdgeInsets.all(1.5),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                GlobalValues.roundedEdges,
              )),
              color: optionalColor ??
                  ColorGenerator.fromHex(GlobalValues.calcButtonColor),
              child: Container(
                child: Text(
                  text,
                  style: Theme.of(ctx).textTheme.headline6.copyWith(
                        color: ColorGenerator.fromHex('#D1D1D1'),
                      ),
                ),
                alignment: Alignment.center,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBackspaceButton(String text, BuildContext ctx,
      {Function onTap, Color optionalColor}) {
    return Expanded(
      flex: 1,
      child: Material(
        color: ColorGenerator.fromHex(GlobalValues.calcBackgroundColor),
        child: InkWell(
          splashColor: Colors.grey,
          onTap: () {
            widget.controller.updateValue('<');
            if (!widget.controller.decimalInUse) {
              decimalColor =
                  ColorGenerator.fromHex(GlobalValues.calcButtonColor);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(1.5),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                GlobalValues.roundedEdges,
              )),
              color: optionalColor ??
                  ColorGenerator.fromHex(GlobalValues.calcButtonColor),
              child: Container(
                child: Text(
                  text,
                  style: Theme.of(ctx).textTheme.headline6.copyWith(
                        color: ColorGenerator.fromHex('#D1D1D1'),
                      ),
                ),
                alignment: Alignment.center,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildEnterButton(String text, BuildContext ctx) {
    return InkWell(
      onTap: () {
        HapticFeedback.vibrate();
        double number = widget.controller.getEntry();

        if (number != null) {
          print('This amount was entered ' + number.toString());
        } else
          print('nothing eligible was entered');
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            GlobalValues.roundedEdges,
          ),
        ),
        color: ColorGenerator.fromHex(GlobalValues.calcButtonColor),
        child: Container(
          child: Text(
            text,
            style: Theme.of(ctx).textTheme.headline6.copyWith(
                  color: ColorGenerator.fromHex('#D1D1D1'),
                ),
          ),
          alignment: Alignment.center,
        ),
      ),
    );
  }
}

class CalculatorController {
  double value;
  String _enteredValue;
  List<Function> listeners;

  bool decimalInUse;
  bool _entryGate;

  CalculatorController() {
    listeners = new List<Function>();
    _enteredValue = '';
    decimalInUse = false;
    _entryGate = true;
  }

  void addListener(Function(String formatedText) function) {
    if (function != null)
      listeners.add(function);
    else
      throw Exception('LISTENER CANNOT NOTIFY NULL FUNCTION');
  }

  double getEntry() {
    if (_enteredValue != '.' || _enteredValue != '') {
      try {
        double entry = double.parse(_enteredValue);

        if (entry == 0) return null;

        return entry;
      } catch (Exception) {
        return null;
      }
    }
    return null;
  }

  /*
   *  Notifies all functions in the Listeners list 
   * 
   */
  void _notifyListeners() {
    for (Function listener in listeners) {
      listener(_prepareListenersText());
    }
  }

  Function(bool allowEntry) _notifySplash;
  attachSplashNotifier(Function(bool entryPassed) function) {
    _notifySplash = function;
  }

  /* 
   * Prepares text for an appealing visual.
   *
   *  TODO: Plausbile flaw is that _enteredValue can at some point
   *  only equal to '.'
   */
  String _prepareListenersText() {
    var listenersText = _enteredValue.length != 0 ? _enteredValue : '0.00';

    // Checks whether to add a zero in front or not, without interfering with
    // _enteredText
    if (decimalInUse) {
      List<String> words = _enteredValue.split('.');

      String firstWord = words.first;
      String secondWord = words.last;

      // This adds a zero to the beginning if user inputs a decimal
      // to begin with
      if (firstWord.length == 0) {
        listenersText = '0.' + secondWord.padRight(2, '0');
      }
      // User inputed values in front of decimal
      else {
        listenersText = firstWord + '.' + secondWord.padRight(2, '0');
      }

      // This closes the entryGate the second no more entries are allowed.
      // Only backspace can reopen it.
      if (secondWord.length >= 2) {
        _openGate(false);
      }
    }

    // Decimal not in use
    else if (_enteredValue.length != 0) {
      listenersText += '.00';
    }

    return listenersText;
  }

  /*
   *  This allows/disallows any entries into the controller. 
   */
  _openGate(bool openGate) {
    _entryGate = openGate;
    _notifySplash(openGate);
  }

  /*
   *  Removes and returns the last char in _enteredText
   *  Returns an empty String if nothing to remove.
   */
  _backspace() {
    String removedChar;

    // Open entryGate if closed
    if (!_entryGate) _openGate(true);

    if (_enteredValue.length > 0) {
      removedChar = String.fromCharCode(
          _enteredValue.codeUnitAt(_enteredValue.length - 1));

      // re-enable decimal button
      if (removedChar == '.') {
        decimalInUse = false;
      }
      _enteredValue = _enteredValue.substring(0, _enteredValue.length - 1);
      return removedChar;
    }
    // Nothing to delete
    else {
      _enteredValue = '';
      return '';
    }
  }

  /*
   * Really only used by CalculatorView. Updates _enteredValue with the passed (v)alue
   */
  updateValue(String entryChar) {
    if (_entryGate || entryChar == '<') {
      HapticFeedback.vibrate();
      switch (entryChar) {
        // Backspace pressed
        case '<':
          _backspace();
          break;

        case '1':
          _enteredValue += 1.toString();
          break;

        case '2':
          _enteredValue += 2.toString();
          break;

        case '3':
          _enteredValue += 3.toString();
          break;

        case '4':
          _enteredValue += 4.toString();
          break;

        case '5':
          _enteredValue += 5.toString();
          break;

        case '6':
          _enteredValue += 6.toString();
          break;

        case '7':
          _enteredValue += 7.toString();
          break;

        case '8':
          _enteredValue += 8.toString();
          break;

        case '9':
          _enteredValue += 9.toString();
          break;

        case '0':
          if (_enteredValue.length > 0) _enteredValue += 0.toString();
          break;

        case '.':
          if (!decimalInUse) {
            _enteredValue += '.';
            decimalInUse = true;
          }
          break;

        case '+':
          //TODO: Add Addition functionality
          print('Addition coming soon');
          break;

        case '-':
          print('Subtraction coming soon');
          //TODO: Add Substraction functionality
          break;

        default:
          throw Exception('INVALID CALCULATOR ENTRY');
      }

      _notifyListeners();
    }
  }

  dispose() {
    this.value = null;
    listeners.clear();
    listeners = null;
  }
}
