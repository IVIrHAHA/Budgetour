import 'package:budgetour/tools/GlobalValues.dart';
import 'package:common_tools/ColorGenerator.dart';
import 'package:flutter/material.dart';

class CalculatorView extends StatelessWidget {
  final CalculatorController controller;

  CalculatorView(this.controller);

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
              child: buildEnterButton('Enter', context, onTap: () {
                // print('pressed enter');
              }),
            )
          ],
        ),
      ),
    );
  }

/*
 * Build number pad 
 */
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
                    buildButton('.', context, onTap: () {
                      controller.updateValue('.');
                    }),
                    buildButton('0', context),
                    buildButton('bks', context, onTap: () {
                      controller.updateValue('<');
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

  /*
   * If text is not an integeter then an onTap function must be passed. 
   */
  Widget buildButton(String text, BuildContext ctx, {Function onTap}) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: onTap ??
            () {
              controller.updateValue(text);
            },
        child: Padding(
          padding: const EdgeInsets.all(1.5),
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
              GlobalValues.roundedEdges,
            )),
            color: Colors.black,
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
            controller.updateValue(text);
          },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            GlobalValues.roundedEdges,
          ),
        ),
        color: Colors.black,
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
  String enteredValue;
  List<Function> listeners;

  bool periodInUse;

  CalculatorController() {
    listeners = new List<Function>();
    enteredValue = '';
    periodInUse = false;
  }

  addListener(Function(String v) listener) {
    listeners.add(listener);
  }

  _notifyListeners() {
    listeners[0](enteredValue.length != 0 ? enteredValue : '0');
  }

  updateValue(String v) {
    switch (v) {
      // Backspace pressed
      case '<':
        if (enteredValue.length > 0) {
          if (enteredValue.endsWith('.')) {
            periodInUse = false;
          }
          enteredValue = enteredValue.substring(0, enteredValue.length - 1);
        } else
          enteredValue = '';

        break;

      case '1':
        enteredValue += 1.toString();
        break;

      case '2':
        enteredValue += 2.toString();
        break;

      case '3':
        enteredValue += 3.toString();
        break;

      case '4':
        enteredValue += 4.toString();
        break;

      case '5':
        enteredValue += 5.toString();
        break;

      case '6':
        enteredValue += 6.toString();
        break;

      case '7':
        enteredValue += 7.toString();
        break;

      case '8':
        enteredValue += 8.toString();
        break;

      case '9':
        enteredValue += 9.toString();
        break;

      case '0':
        if (enteredValue.length > 0) enteredValue += 0.toString();
        break;

      case '.':
        if (!periodInUse) {
          enteredValue += '.';
          periodInUse = true;
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

  dispose() {
    this.value = null;
    listeners.clear();
    listeners = null;
  }
}
