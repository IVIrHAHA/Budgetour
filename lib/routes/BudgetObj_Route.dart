import 'package:budgetour/objects/BudgetObject.dart';
import 'package:budgetour/tools/GlobalValues.dart';
import 'package:budgetour/widgets/EnterTransactionPage.dart';
import 'package:budgetour/widgets/standardized/EnhancedListTIle.dart';
import 'package:common_tools/ColorGenerator.dart';
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
  var _screenSize;

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

    _screenSize = MediaQuery.of(context).size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: appBar,
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext ctx) {
    return TabBarView(
      controller: _controller,
      children: [
        // Withdraw Page
        EnterTransactionPage(),

        // History Page
        buildHistoryPage(ctx),
      ],
    );
  }

  /*
   *  Contents of Transaction History Page
   */
  Widget buildHistoryPage(BuildContext ctx) {
    int workingMonth;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Heading
          Flexible(
            flex: 0,
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Text(
                            'Transaction History',
                            style: Theme.of(ctx).textTheme.headline6,
                          ),
                          Icon(Icons.unfold_more)
                        ],
                      ),
                    ),
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
            child: _buildTransactionListView(workingMonth),
          ),
        ],
      ),
    );
  }

  /*
   *  Builds transaction list view. A list of all transactions 
   *  seperated by Month.
   */
  SingleChildScrollView _buildTransactionListView(int workingMonth) {
    return SingleChildScrollView(
      child: Column(
        children: widget.budgetObject.getTransactions.map((transaction) {
          // Keep working month the same if already assigned
          // otherwise working month goes to first element in list
          workingMonth = workingMonth ?? transaction.date.month;

          bool monthChanged = false;
          // Month has changed
          if (transaction.date.month != workingMonth) {
            monthChanged = true;
            workingMonth = transaction.date.month;
          }

          return monthChanged
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child:
                          Text(DateFormat('LLLL y').format(transaction.date)),
                    ),
                    TransactionTile(
                      transaction: transaction,
                    ),
                  ],
                )
              : TransactionTile(transaction: transaction);
        }).toList(),
      ),
    );
  }
}
