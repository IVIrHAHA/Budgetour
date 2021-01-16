/*
 *  This widget/interface gives the dev the appBar and 
 *  TabView already formatted. 
 */

import 'package:budgetour/models/Meta/QuickStat.dart';
import 'package:budgetour/models/finance_objects/FinanceObject.dart';

import '../../tools/GlobalValues.dart';
import 'package:common_tools/ColorGenerator.dart';
import 'package:flutter/material.dart';

class MyAppBarView extends StatefulWidget {
  /// If null, will build the first [tabPages] provided
  final List<Widget> tabTitles;
  final List<Widget> tabPages;
  final QuickStat stat1, stat2;
  final String headerName;

  MyAppBarView(
      {this.headerName, this.tabPages, this.tabTitles, this.stat1, this.stat2});

  @override
  _MyAppBarViewState createState() => _MyAppBarViewState();
}

class _MyAppBarViewState extends State<MyAppBarView>
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
              widget.headerName,
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          color: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(GlobalValues.roundedEdges),
            side: BorderSide(
                color: ColorGenerator.fromHex(GColors.borderColor), width: 1),
          ),
        ),

        /// TODO: Add room for second stat
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            widget.stat1 != null ?  Text(widget.stat1.title) : Container(),
            widget.stat1 != null ? widget.stat1.getValueToString() : Container(),
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: appBar,
      body:
          widget.tabTitles != null ? buildBody(context) : widget.tabPages.first,
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
