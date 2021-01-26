import 'package:budgetour/InitTestData.dart';
import 'package:budgetour/Widgets/FinanceTile.dart';
import 'package:budgetour/models/CategoryListManager.dart';
import 'package:budgetour/pages/CreateFixedPaymentPage.dart';
import 'package:budgetour/pages/CreateBudgetPage.dart';
import 'package:budgetour/pages/MenuListPage.dart';
import 'package:budgetour/routes/Income_Route.dart';
import 'package:budgetour/tools/GlobalValues.dart';
import 'package:budgetour/widgets/standardized/InfoTile.dart';
import 'package:common_tools/StringFormater.dart';
import 'package:flutter/foundation.dart';
import 'models/finance_objects/CashOnHand.dart';
import 'models/finance_objects/FinanceObject.dart';
import 'package:flutter/material.dart';
import 'package:common_tools/ColorGenerator.dart';

void main() {
  CashOnHand cashBag = CashOnHand.instance;
  cashBag.logTransaction(
      cashBag.reportIncome(10000)..description = 'Initial Deposit');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          primaryColor: ColorGenerator.createMaterialColor('000000'),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: ThemeData.light().textTheme.copyWith(
                  headline5: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ))),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  final CategoryListManager manager = CategoryListManager.instance;

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
    TextStyle style = TextStyle(fontSize: 14);
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.unfold_more),
            title: Text('macro'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.unfold_less),
            title: Text('micro'),
          )
        ],
      ),
      appBar: AppBar(
        title: ListTile(
          // Category Info 1
          leading: Column(
            children: [
              Text('Allocated'),
              Text(
                '\$ ${Format.formatDouble(
                  CategoryListAnalyzer.getAllocatedAmount(
                      CategoryListManager.instance.essentials),
                  0,
                )}',
              ),
            ],
          ),

          // Add Finance Object Button
          title: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) {
                    return buildCreateFinanceObjectMenu(context);
                  },
                ),
              );
            },
            child: Icon(
              Icons.add_circle_outline,
              size: 32,
            ),
          ),

          // Category Info 2
          trailing: Column(
            children: [
              Text('Pending'),
              Text(
                '\$ ${Format.formatDouble(
                  CategoryListAnalyzer.getUnspentAmount(
                      CategoryListManager.instance.essentials),
                  0,
                )}',
              ),
            ],
          ),
        ),

        // Create Category Tabs
        bottom: TabBar(
          controller: _controller,
          tabs: CategoryType.values.map((e) {
            // Use Enums for titles
            String label = e.toString().split('.').last;
            return Text(
              label,
              style: style,
              overflow: TextOverflow.ellipsis,
            );
          }).toList(),
        ),
      ),

      // Build Body
      body: Container(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Draggable<double>(
                dragAnchor: DragAnchor.pointer,
                data: CashOnHand.instance.cashAmount,
                onDragCompleted: () {
                  setState(() {
                    /// Update main screen ui
                  });
                },
                feedback: Card(
                  color: Colors.black,
                  child: Text(
                    '\$ ${Format.formatDouble(
                      CashOnHand.instance.cashAmount,
                      2,
                    )}',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                childWhenDragging: Container(),
                child: _allocationInfoTile(context),
              ),
            ),
            Expanded(
              flex: 12,
              child: TabBarView(
                controller: _controller,
                children: [
                  TileLayout(widget.manager.essentials),
                  TileLayout(widget.manager.securities),
                  TileLayout(widget.manager.goals),
                  TileLayout(widget.manager.lifestyle),
                  TileLayout(widget.manager.misc),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  InfoTile _allocationInfoTile(BuildContext context) {
    return InfoTile(
      title: 'Unallocated',
      padding: const EdgeInsets.symmetric(
        horizontal: GlobalValues.defaultTilePadding + GlobalValues.financeTileMargin,
      ),
      infoText: '\$ ${Format.formatDouble(
        CashOnHand.instance.cashAmount,
        2,
      )}',
      infoTextColor: ColorGenerator.fromHex(GColors.redish),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) {
            return IncomeRoute();
          }),
        );
      },
    );
  }

  MenuListPage buildCreateFinanceObjectMenu(BuildContext context) {
    /// [_controller.index] gets the tab name of the TabBarView. Which
    /// is correlated with the [CategoryType] enum list
    /// This lets any created [FinanceObject] to be added to the correct
    /// category
    return MenuListPage({
      Text('Budget', style: Theme.of(context).textTheme.headline5): () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) {
              return CreateBudgetPage(CategoryType.values[_controller.index]);
            },
          ),
        );
      },
      Text(
        'Bill',
        style: Theme.of(context).textTheme.headline5,
      ): () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) {
              return CreateFixedPaymentPage(
                  CategoryType.values[_controller.index]);
            },
          ),
        );
      },
      Text(
        'Goal',
        style: Theme.of(context).textTheme.headline5,
      ): () {
        print('create goal');
      },
      Text(
        'Fund',
        style: Theme.of(context).textTheme.headline5,
      ): () {
        print('create fund');
      },
      Text(
        'Investment',
        style: Theme.of(context).textTheme.headline5,
      ): () {
        print('create investment');
      },
    });
  }
}

class TileLayout extends StatelessWidget {
  final List<FinanceObject> financeList;

  TileLayout(this.financeList);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: financeList.length != 0
          ? GridView.count(
              scrollDirection: Axis.vertical,
              // padding: const EdgeInsets.all(2),
              crossAxisCount: 2,
              children: financeList.map((element) {
                return FinanceTile(element);
              }).toList(),
            )
          : Center(child: Text('Nothing to display')),
    );
  }
}
