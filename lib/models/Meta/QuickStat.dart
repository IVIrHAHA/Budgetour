import 'package:common_tools/StringFormater.dart';
import 'package:flutter/material.dart';

class QuickStat {
  final String title;
  final double value;

  final Future<String> evaluateValue;

  QuickStat({this.title, this.value, this.evaluateValue});

  hasToEvaluate() {
    return evaluateValue != null;
  }

  /// Return the value or evaluatedValue as a Widget
  Widget getValueToString() {
    /// Return predetermined stat value
    if (!hasToEvaluate()) {
      return Text('${Format.formatDouble(value, 2)}');
    }

    /// Evalute Future
    else {
      return FutureBuilder<String>(
        future: evaluateValue,
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data);
          } else if (snapshot.hasError) {
            return Text('errr');
          } else {
            return Text('berr');
          }
        },
      );
    }
  }
}
