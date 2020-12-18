import 'package:budgetour/tools/GlobalValues.dart';
import 'package:common_tools/common_tools.dart';
import 'package:flutter/material.dart';

class BudgetObjRoute extends StatefulWidget {
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

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      title: ListTile(
        leading: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              'Food',
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
        Container(
          child: Text('History'),
        ),
      ],
    );
  }
}
