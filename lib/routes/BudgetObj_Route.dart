import 'package:budgetour/objects/BudgetObject.dart';
import 'package:budgetour/tools/GlobalValues.dart';
import 'package:budgetour/widgets/standardized/EnhancedListTIle.dart';
import 'package:common_tools/ColorGenerator.dart';
import 'package:flutter/material.dart';
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
  double _screenHeight;

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
          children: [Text('Remaining'), Text('\$100')],
        ),
      ),
      bottom: TabBar(
        controller: _controller,
        tabs: [
          Text('Withdraw'),
          Text('History'),
        ],
      ),
    );

    _screenHeight = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: appBar,
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return TabBarView(
      controller: _controller,
      children: [
        Container(
          alignment: Alignment.center,
          child: Text('Withdraw'),
        ),
        buildHistoryPage(),
      ],
    );
  }

  Widget buildHistoryPage() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [

          // Heading
          Flexible(
            flex: 0,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Transaction Hisotry'),
                EnhancedListTile(
                  leading: Text('date'),
                  center: Text('note'),
                  trailing: Text('amount'),
                )
              ],
            )),
          ),

          // Transaction List
          Flexible(
            flex: 1,
            child: SingleChildScrollView(
              child: Column(
                children:
                    widget.budgetObject.getTransactions.map((transaction) {
                  return TransactionTile(transaction: transaction);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
