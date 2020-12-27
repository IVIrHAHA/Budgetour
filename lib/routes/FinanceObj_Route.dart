import 'package:budgetour/models/FinanceObject.dart';

import '../tools/GlobalValues.dart';
import 'package:common_tools/ColorGenerator.dart';
import 'package:common_tools/StringFormater.dart';
import 'package:flutter/material.dart';

class BudgetObjRoute extends StatefulWidget {
  final FinanceObject financeObject;
  final List<Widget> tabTitles;
  final List<Widget> tabPages;
  final String quickStatTitle, quickStatInfo;

  final Function onEnterPressed;

  BudgetObjRoute({
    @required this.financeObject,
    this.tabPages,
    this.tabTitles,
    this.onEnterPressed,
    this.quickStatInfo,
    this.quickStatTitle,
  });

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
              widget.financeObject.name,
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
            Text(widget.quickStatTitle),
            Text(widget.quickStatInfo),
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
              tabs: widget.tabTitles,
            ),
          ),
        ),
        Expanded(
          flex: 12,
          child: TabBarView(
            controller: _controller,
            children: widget.tabPages,
          ),
        ),
      ],
    );
  }
}
