import 'package:budgetour/tools/GlobalValues.dart';
import 'package:common_tools/ColorGenerator.dart';
import 'package:flutter/material.dart';

class CalculatorView extends StatefulWidget {
  final CalculatorController controller;

  CalculatorView(this.controller);

  @override
  _CalculatorViewState createState() => _CalculatorViewState();
}

class _CalculatorViewState extends State<CalculatorView> {
  Color decimalColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      width: double.infinity,
      color: ColorGenerator.fromHex('#393939'),
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
              child: buildEnterButton('Enter', context, onTap: () {}),
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
                        if (widget.controller.decimalUsed())
                          decimalColor = Colors.grey;
                      });
                    }),
                    buildButton('0', context),
                    buildButton('bks', context, onTap: () {
                      widget.controller.updateValue('<');
                      if (!widget.controller.decimalUsed()) {
                        decimalColor = Colors.black;
                      }
                    }),
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
      child: GestureDetector(
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
            color: optionalColor ?? Colors.black,
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
    );
  }

  Widget buildEnterButton(String text, BuildContext ctx, {Function onTap}) {
    return GestureDetector(
      onTap: onTap ??
          () {
            widget.controller.updateValue(text);
          },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            GlobalValues.roundedEdges,
          ),
        ),
        color: text == '.' && widget.controller.decimalUsed()
            ? Colors.grey
            : Colors.black,
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

  bool _decimalInUse;

  CalculatorController() {
    listeners = new List<Function>();
    _enteredValue = '';
    _decimalInUse = false;
  }

  addListener(Function(String enteredText) function) {
    if (function != null)
      listeners.add(function);
    else
      throw Exception('LISTENER CANNOT NOTIFY NULL FUNCTION');
  }

  bool decimalUsed() {
    return _decimalInUse;
  }

  /*
   *  Notifies all functions in the Listeners list 
   * 
   */
  _notifyListeners() {
    for (Function listener in listeners) {
      listener(_prepareListenersText());
    }
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
    if (_decimalInUse) {
      List<String> words = _enteredValue.split('.');

      String firstWord = words.first;
      String secondWord = words.last;

      // This adds a zero to the beginning if user inputs a decimal
      // to begin with
      if (firstWord.length == 0) {
        listenersText = '0.' + secondWord.padRight(2, '0');
      } else {
        listenersText = firstWord + '.' + secondWord.padRight(2, '0');
      }
    } else if (_enteredValue.length != 0) {
      listenersText += '.00';
    }

    return listenersText;
  }

  /*
   *  Removes and returns the last char in _enteredText
   *  Returns an empty String if nothing to remove.
   */
  _backspace() {
    String removedChar;

    if (_enteredValue.length > 0) {
      // Allows the decimal to be used again
      if (_enteredValue.endsWith('.')) {
        _decimalInUse = false;
      }
      removedChar = String.fromCharCode(
          _enteredValue.codeUnitAt(_enteredValue.length - 1));
      _enteredValue = _enteredValue.substring(0, _enteredValue.length - 1);
      return removedChar;
    } else {
      _enteredValue = '';
      return '';
    }
  }

  /*
   * Really only used by CalculatorView. Updates enteredText with the passed (v)alue
   */
  updateValue(String entry) {
    bool allowEntry = true;

    if (_decimalInUse && entry != '<') {
      String secondWord = _enteredValue.split('.').last;
      if (secondWord.length >= 2) {
        allowEntry = false;
      }
    }

    if (allowEntry) {
      switch (entry) {
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
          if (!_decimalInUse) {
            _enteredValue += '.';
            _decimalInUse = true;
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
