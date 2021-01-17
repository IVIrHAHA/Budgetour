import 'package:common_tools/StringFormater.dart';
import 'package:flutter/material.dart';

class QuickStat {
  /// Name associated with Values
  final String title;
  /// Const value to be displayed
  final double value;

  /// Takes a future which can be caluclated at a later time in case
  /// evaluting the value is a computing heavy process
  final Future<String> evaluateValue;

  /// If non-null, this is passed back without evaluation.
  final String lazyValue;

  QuickStat({this.title, this.value, this.evaluateValue, this.lazyValue});

  /// Checks whether this stat needs to do some processing
  hasToEvaluate() {
    return evaluateValue != null && lazyValue == null;
  }

  /// Return the value or evaluatedValue as a Widget
  Widget getValueToString({TextStyle style}) {
    
    if(lazyValue != null) {
      return Text(lazyValue, style: style);
    }
    /// Return predetermined stat value
    else if (!hasToEvaluate()) {
      return Text('${Format.formatDouble(value, 2)}', style: style);
    }

    /// Evalute Future
    else {
      return FutureBuilder<String>(
        future: evaluateValue,
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data, style: style);
          } else if (snapshot.hasError) {
            return Text('errr', style: style);
          } else {
            return Text('berr', style: style);
          }
        },
      );
    }
  }
}
