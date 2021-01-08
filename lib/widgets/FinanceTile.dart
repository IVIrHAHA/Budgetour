import 'package:budgetour/models/finance_objects/LabelObject.dart';
import 'package:common_tools/StringFormater.dart';

import '../models/finance_objects/FinanceObject.dart';
import '../tools/GlobalValues.dart';
import 'package:common_tools/ColorGenerator.dart';
import 'package:flutter/material.dart';

class FinanceTile extends StatefulWidget {
  final FinanceObject financeObj;

  FinanceTile(this.financeObj);

  @override
  _FinanceTileState createState() => _FinanceTileState();
}

class _FinanceTileState extends State<FinanceTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _openTile(context);
      },
      child: Card(
        color: widget.financeObj.getTileColor(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(GlobalValues.roundedEdges),
          side: BorderSide(
              style: BorderStyle.solid,
              width: 1,
              color: ColorGenerator.fromHex(GColors.borderColor)),
        ),
        margin: EdgeInsets.all(8.0),
        child: buildContents(),
      ),
    );
  }

  Column buildContents() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: Text(widget.financeObj.name),
          trailing: Icon(Icons.more_vert),
        ),
        ListTile(
          title: Text(_getLabelTitle(widget.financeObj.label_1)),
          trailing: Text(_getLabelValues(widget.financeObj.label_1)),
        ),
        Text(widget.financeObj.label_2 ?? 'hello 2'),
      ],
    );
  }

  String _getLabelTitle(LabelObject label) {
    if (label != null && label.title != null)
      return label.title;
    else
      return '';
  }

  String _getLabelValues(LabelObject label) {
    if (label != null) {
      /// Value has been pre-determined as a constant
      if (label.value != null) {
        return Format.formatDouble(label.value, 2);
      }

      /// Value needs to be evaluated in the form of a future
      /// *** [Future<double>] is needed as to not slow down
      ///     main UI thread, (Swiping between categories and loading)
      ///     all the financeTiles
      else if(label.evaluateValue != null) {
        
      }
    }
    
    return '';
  }

  /// TEST BLOCK:::
  /// ---------------------------------------------------------------------------
  double valueReturned;
  double handlePromisedValue() {
    Future<double> promiseForValue = widget.financeObj.label_1.evaluateValue;

    // Evaluate
    if (valueReturned == null && promiseForValue != null) {
      promiseForValue.then((value) {
        setState(() {
          valueReturned = value;
        });
      }, onError: (_) {
        valueReturned = null;
      });

      return 0;
    } else
      return valueReturned;
  }

  /// ---------------------------------------------------------------------------

  _openTile(BuildContext ctx) {
    Navigator.of(ctx).push(
      MaterialPageRoute(
        builder: (_) {
          return widget.financeObj.getLandingPage();
        },
      ),
    );
  }
}
