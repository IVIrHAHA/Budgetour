import '../tools/GlobalValues.dart';
import '../widgets/standardized/CalculatorView.dart';
import '../widgets/standardized/EnteredHeader.dart';
import '../widgets/standardized/CalculatorInputDisplay.dart';
import 'package:flutter/material.dart';

/// Versatile widget which allows for a formatted view of
/// [EnteredHeader], [CalculatorInputDisplay] and [CalculatorView].

class EnterTransactionPage extends StatefulWidget {
  /// [onEnterPressed] will be called when [CalculatorView]
  /// "enter" button is pressed.
  /// [BuildContext] is needed for the [Navigator]
  final Function(double, BuildContext) onEnterPressed;
  final String headerTitle;
  final Color headerColorAccent;

  final double initialValue;

  const EnterTransactionPage({
    @required this.onEnterPressed,
    @required this.headerTitle,
    this.initialValue,
    this.headerColorAccent = Colors.grey,
  });

  @override
  _EnterTransactionPageState createState() => _EnterTransactionPageState();
}

class _EnterTransactionPageState extends State<EnterTransactionPage> {
  CalculatorController calcController;

  @override
  void initState() {
    double defaultDisplayValue;

    if (widget.initialValue != null && widget.initialValue != 0)
      defaultDisplayValue = widget.initialValue;

    calcController = CalculatorController(defaultValue: defaultDisplayValue);
    super.initState();
  }

  @override
  void dispose() {
    calcController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// [EnteredHeader] and [CalculatorInputDisplay]
          Flexible(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: buildDisplay(),
            ),
          ),

          /// [CalculatorView]
          Flexible(
            flex: 3,
            child: CalculatorView(
              MediaQuery.of(context).size.height / 2,
              controller: calcController,
              onEnterPressed: (entry) {
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

  /// Builds the portion above the calculator view
  Widget buildDisplay() {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: GlobalValues.defaultMargin, vertical: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          EnteredHeader(
            text: widget.headerTitle,
            color: widget.headerColorAccent,
          ),
          CalculatorInputDisplay(
            controller: calcController,
          ),
          //TODO: implement options menu
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
