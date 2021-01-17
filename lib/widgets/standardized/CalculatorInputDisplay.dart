import 'package:budgetour/widgets/standardized/CalculatorView.dart';
import 'package:common_tools/StringFormater.dart';
import 'package:flutter/material.dart';

class CalculatorInputDisplay extends StatefulWidget {
  // final bool focusable;
  final Color indicatorColor, textColor;
  final CalculatorController controller;
  final double indicatorSize;

  CalculatorInputDisplay({
    this.controller,
    this.textColor = Colors.black,
    this.indicatorColor = Colors.grey,
    this.indicatorSize = 2,
  });

  @override
  _CalculatorInputDisplayState createState() => _CalculatorInputDisplayState();
}

class _CalculatorInputDisplayState extends State<CalculatorInputDisplay> {
  String displayedText;

  _CalculatorInputDisplayState() {
    displayedText = '\$ 0.00';
  }

  @override
  void initState() {
    // Make the calculatorView control what is displayed directly
    // Otherwise, parent controls what is displayed
    if (widget.controller.defaultValue == null && widget.controller != null) {
      widget.controller.addListener((formatedText) {
        setState(() {
          displayedText = '\$ ' + formatedText;
        });
      });
    } 
    
    /// Parent wants [CalculatorController.defaultValue] to be displayed
    else if (widget.controller.defaultValue != null &&
        widget.controller != null) {
      // Sets initial value text view, if a defaultValue was provided to controller
      // beyond this the controller will return defaultValue view the formatedText params
      displayedText =
          '\$ ' + '${Format.formatDouble(widget.controller.defaultValue, 2)}';

      widget.controller.addListener((formatedText) {
        setState(() {
          displayedText = '\$ ' + formatedText;
        });
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            displayedText,
            style: Theme.of(context).textTheme.headline5.copyWith(
                color: widget.textColor, fontWeight: FontWeight.normal),
          ),
          Divider(
            color: widget.indicatorColor,
            thickness: widget.indicatorSize,
          ),
        ],
      ),
    );
  }
}
