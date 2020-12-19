import 'package:flutter/material.dart';

class CalculatorView extends StatelessWidget {
  final CalculatorController controller;

  CalculatorView(this.controller);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildButton('1'),
                buildButton('2'),
                buildButton('3'),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildButton('4'),
              buildButton('5'),
              buildButton('6'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildButton('7'),
              buildButton('8'),
              buildButton('9'),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildButton(String text) {
    return Flexible(
      fit: FlexFit.tight,
      child: Card(
        child: GestureDetector(
          onTap: () {
            controller.updateValue(text);
          },
          child: Container(
            child: Text(text),
            padding: EdgeInsets.all(8.0),
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
}
