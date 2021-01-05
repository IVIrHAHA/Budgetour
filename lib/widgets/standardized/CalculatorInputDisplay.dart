import 'package:budgetour/tools/GlobalValues.dart';
import 'package:budgetour/widgets/standardized/CalculatorView.dart';
import 'package:common_tools/ColorGenerator.dart';
import 'package:flutter/material.dart';

class CalculatorInputDisplay extends StatefulWidget {
  final String overrideText;
  // final bool focusable;
  final Color indicatorColor, textColor;
  final CalculatorController controller;
  final double indicatorSize;

  CalculatorInputDisplay({
    this.controller,
    this.overrideText,
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
    if (widget.overrideText == null && widget.controller != null) {
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
    displayedText = widget.overrideText ?? displayedText;
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