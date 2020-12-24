import 'package:budgetour/pages/TransactionHistoryPage.dart';

import '../models/BudgetObject.dart';
import '../models/Transaction.dart';
import '../tools/GlobalValues.dart';
import '../pages/EnterTransactionPage.dart';
import '../widgets/standardized/EnhancedListTile.dart';
import 'package:common_tools/ColorGenerator.dart';
import 'package:common_tools/StringFormater.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/TransactionTile.dart';

class BudgetObjRoute extends StatefulWidget {
  final BudgetObject budgetObject;

  BudgetObjRoute(this.budgetObject);

  @override
  _BudgetObjRouteState createState() => _BudgetObjRouteState();
}

class _BudgetObjRouteState extends State<BudgetObjRoute>
    with TickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    _controller = TabController(
      length: 2,
      vsync: this,
      initialIndex: 0,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _addTransaction(Transaction transaction) {
    setState(() {
      transaction.description = 'new transaction';
      widget.budgetObject.logTransaction(transaction);
    });
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      title: ListTile(
        leading: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              widget.budgetObject.name,
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          color: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(GlobalValues.roundedEdges),
            side: BorderSide(
                color: ColorGenerator.fromHex(GlobalValues.borderColor),
                width: 1),
          ),
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('Remaining'),
            Text(
              '\$${Format.formatDouble(widget.budgetObject.currentBalance, 0)}',
            )
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: appBar,
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext ctx) {
    const TextStyle style = TextStyle(color: Colors.black);
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Material(
            elevation: 3,
            color: Colors.white,
            child: TabBar(
              indicatorColor: Colors.grey,
              controller: _controller,
              tabs: [
                Text(
                  'Withdraw',
                  style: style,
                ),
                Text(
                  'History',
                  style: style,
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 12,
          child: TabBarView(
            controller: _controller,
            children: [
              // Withdraw Page
              EnterTransactionPage(_addTransaction),

              // History Page
              TransactionHistoryPage(widget.budgetObject),
            ],
          ),
        ),
      ],
    );
  }

  
}
