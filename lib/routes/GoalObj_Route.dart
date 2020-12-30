import 'package:budgetour/models/finance_objects/GoalObject.dart';
import 'package:budgetour/pages/EnterTransactionPage.dart';
import 'package:budgetour/tools/GlobalValues.dart';
import 'package:budgetour/widgets/standardized/MyAppBarView.dart';
import 'package:common_tools/ColorGenerator.dart';
import 'package:flutter/material.dart';

class GoalObjRoute extends StatefulWidget {
  final GoalObject goalObject;

  GoalObjRoute(this.goalObject);

  @override
  _GoalObjRouteState createState() => _GoalObjRouteState();
}

class _GoalObjRouteState extends State<GoalObjRoute> {
  @override
  Widget build(BuildContext context) {
    const TextStyle style = TextStyle(color: Colors.black);

    return MyAppBarView(
      financeObject: widget.goalObject,
      tabTitles: [
        Text('Deposit', style: style),
        Text('History', style: style),
      ],
      tabPages: [
        EnterTransactionPage(
          onEnterPressed: (_, __) {
            print('hello');
          },
          headerTitle: 'Deposit',
          headerColorAccent: ColorGenerator.fromHex(GColors.positiveColor),
        )
      ],
    );
  }
}
