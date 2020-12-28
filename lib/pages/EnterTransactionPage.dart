import 'package:budgetour/tools/GlobalValues.dart';
import 'package:budgetour/widgets/standardized/CalculatorView.dart';
import 'package:budgetour/widgets/standardized/EnteredHeader.dart';
import 'package:budgetour/widgets/standardized/InputDisplay.dart';
import 'package:flutter/material.dart';

class EnterTransactionPage extends StatefulWidget {
  final Function(double, BuildContext) onEnterPressed;
  final String processName;
  final Color processNameColor;

  EnterTransactionPage({
    @required this.onEnterPressed,
    @required this.processName,
    this.processNameColor = Colors.grey,
  });

  @override
  _EnterTransactionPageState createState() => _EnterTransactionPageState();
}

class _EnterTransactionPageState extends State<EnterTransactionPage> {
  CalculatorController controller;

  @override
  void initState() {
    controller = CalculatorController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: buildDisplay(),
            ),
          ),
          Flexible(
            flex: 3,
            child: CalculatorView(
              controller,
              (entry) {
                widget.onEnterPressed(
                  entry,
                  context,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDisplay() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: GlobalValues.defaultMargin, vertical: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          EnteredHeader(
            text: widget.processName,
            color: widget.processNameColor,
          ),
          InputDisplay(controller: controller),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('Additional Options'),
              Icon(Icons.add_circle_outline),
            ],
          ),
        ],
      ),
    );
  }
}
