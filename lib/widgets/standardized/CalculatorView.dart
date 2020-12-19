import 'package:budgetour/tools/GlobalValues.dart';
import 'package:flutter/material.dart';

class CalculatorView extends StatelessWidget {
  final CalculatorController controller;

  CalculatorView(this.controller);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildButton('1', context),
              buildButton('2', context),
              buildButton('3', context),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildButton('4', context),
              buildButton('5', context),
              buildButton('6', context),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildButton('7', context),
              buildButton('8', context),
              buildButton('9', context),
            ],
          ),
        ],
      ),
    );
  }

  /*
   * If text is not an integeter then an onTap function must be passed. 
   */
  Widget buildButton(String text, BuildContext ctx, {Function onTap}) {
    return Flexible(
      fit: FlexFit.tight,
      child: GestureDetector(
        onTap: onTap ??
            () {
              controller.updateValue(text);
            },
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
            GlobalValues.roundedEdges,
          )),
          color: Colors.black,
          child: Container(
            child: Text(
              text,
              style: Theme.of(ctx)
                  .textTheme
                  .headline6
                  .copyWith(color: Colors.white),
            ),
            alignment: Alignment.center,
          ),
        ),
      ),
    );
  }
}

class CalculatorController {
  double value;
  List<Function> listeners;

  CalculatorController() {
    listeners = new List<Function>();
  }

  addListener(Function(double v) listener) {
    listeners.add(listener);
  }

  _notifyListeners() {
    listeners[0](this.value);
  }

  updateValue(String v) {
    this.value = double.parse(v);
    _notifyListeners();
  }

  dispose() {
    this.value = null;
    listeners.clear();
    listeners = null;
  }
}
