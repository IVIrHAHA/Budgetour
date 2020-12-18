import 'package:budgetour/InitTestData.dart';
import 'package:budgetour/Widgets/FinanceTile.dart';
import 'package:budgetour/objects/BudgetObject.dart';
import 'package:budgetour/objects/FinanceObject.dart';
import 'package:flutter/material.dart';
import 'package:common_tools/common_tools.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primaryColor: ColorGenerator.createMaterialColor('000000'),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: ThemeData.light().textTheme.copyWith(
                  headline5: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ))),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  TabController _controller;
  
  @override
  void initState() {
    _controller = TabController(
      initialIndex: 0,
      length: 5,
      vsync: this,
    );
    InitTestData.initTileList();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          leading: Text('Allocated'),
          title: Icon(
            Icons.add_circle_outline,
            size: 32,
          ),
          trailing: Text('Pending'),
        ),
        bottom: TabBar(
          controller: _controller,
          tabs: [
            Text(
              'Essentials',
              style: TextStyle(fontSize: 10),
            ),
            Text(
              'Security',
              style: TextStyle(fontSize: 10),
            ),
            Text(
              'Goals',
              style: TextStyle(fontSize: 10),
            ),
            Text(
              'Lifestyle',
              style: TextStyle(fontSize: 10),
            ),
            Text(
              'Misc',
              style: TextStyle(fontSize: 10),
            ),
          ],
        ),
      ),
      body: Container(
        child: TabBarView(
          controller: _controller,
          children: [
            BudgetPage(InitTestData.dummyFOList),
            buildPage('Security'),
            buildPage('Goals'),
            buildPage('Lifestyle'),
            buildPage('Misc'),
          ],
        ),
      ),
    );
  }

  Center buildPage(String text) {
    return Center(
      child: Text(
        text,
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

class BudgetPage extends StatelessWidget {
  final List<FinanceObject> financeList;

  BudgetPage(this.financeList);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.count(
        crossAxisCount: 2,
        children: financeList.map((element) {
          return FinanceTile(element);
        }).toList(),
      ),
    );
  }
}
