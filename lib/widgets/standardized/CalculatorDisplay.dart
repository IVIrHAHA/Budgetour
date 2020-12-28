import 'package:budgetour/tools/GlobalValues.dart';
import 'package:budgetour/widgets/standardized/CalculatorView.dart';
import 'package:common_tools/ColorGenerator.dart';
import 'package:flutter/material.dart';

class CalculatorDisplay extends StatefulWidget {
  final String overrideText;
  final bool focusable;
  final Color indicatorColor;
  final CalculatorController controller;

  CalculatorDisplay(this.controller,
      {this.overrideText, this.focusable, this.indicatorColor});

  @override
  _CalculatorDisplayState createState() => _CalculatorDisplayState();
}

class _CalculatorDisplayState extends State<CalculatorDisplay> {
  String displayedText;

  _CalculatorDisplayState() {
    displayedText = '\$ 0.00';
  }

  @override
  void initState() {
    // Make the calculatorView control what is displayed directly
    // Otherwise, parent controls what is displayed
    if (widget.overrideText == null) {
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
            style: Theme.of(context)
                .textTheme
                .headline5
                .copyWith(color: Colors.black, fontWeight: FontWeight.normal),
          ),
          Divider(
            color: widget.indicatorColor ??
                ColorGenerator.fromHex(GColors.borderColor),
            thickness: 2,
          ),
        ],
      ),
    );
  }
}
