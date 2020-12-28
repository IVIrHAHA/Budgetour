import 'package:budgetour/models/CategoryListManager.dart';
import 'package:budgetour/models/finance_objects/BudgetObject.dart';
import 'package:budgetour/tools/DialogBox.dart';
import 'package:budgetour/tools/GlobalValues.dart';
import 'package:budgetour/widgets/standardized/CalculatorView.dart';
import 'package:budgetour/widgets/standardized/EnteredHeader.dart';
import 'package:budgetour/widgets/standardized/InfoTile.dart';
import 'package:budgetour/widgets/standardized/InputDisplay.dart';
import 'package:common_tools/ColorGenerator.dart';
import 'package:flutter/material.dart';

class CreateBudgetPage extends StatefulWidget {
  @override
  _CreateBudgetPageState createState() => _CreateBudgetPageState();
}

class _CreateBudgetPageState extends State<CreateBudgetPage> {
  CalculatorController controller;
  String budgetName;

  @override
  void initState() {
    controller = CalculatorController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  TextEditingController _textInputController = new TextEditingController();
  void showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final emailField = TextFormField(
          controller: _textInputController,
          keyboardType: TextInputType.emailAddress,
          style: TextStyle(
            color: Colors.black,
          ),
          decoration: InputDecoration(
            labelText: 'Budget Name',
            labelStyle: TextStyle(
              color: Colors.black,
            ),
            hintStyle: TextStyle(
              color: Colors.black,
            ),
          ),
        );

        return CustomAlertDialog(
          content: Container(
            width: MediaQuery.of(context).size.width / 1.3,
            height: MediaQuery.of(context).size.height / 2.5,
            decoration: new BoxDecoration(
              shape: BoxShape.rectangle,
              color: const Color(0xFFFFFF),
              borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
            ),
            child: Column(
              children: [
                Text('enter a name'),
                emailField,
                MaterialButton(
                  child: Container(
                    color: Colors.blue,
                    child: Text('Enter'),
                  ),
                  onPressed: () {
                    setState(() {
                      budgetName = _textInputController.text;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      title: ListTile(
        leading: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: InkWell(
              onTap: () => showAlertDialog(context),
              child: Text(
                budgetName ?? 'Enter Name',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
          ),
          color: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(GlobalValues.roundedEdges),
            side: BorderSide(
                color: ColorGenerator.fromHex(GColors.borderColor), width: 1),
          ),
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('selection 1'),
            Text('selection 2'),
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: appBar,
      body: Column(
        children: [
          Flexible(
            flex: 1,
            child: InfoTile(
              title: 'Budget',
            ),
          ),
          Flexible(
            flex: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: GlobalValues.defaultMargin),
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  EnteredHeader(
                    text: 'Square',
                    text2: ' Details',
                    color: ColorGenerator.fromHex(GColors.blueish),
                  ),
                  Text(
                    'How much is going into this budget?',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  InputDisplay(
                    controller: controller,
                    indicatorColor: ColorGenerator.fromHex(GColors.blueish),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 0, // Use CalculatorView default height
            child: CalculatorView(controller, (_) {
              CategoryListManager.instance.add(
                BudgetObject(title: budgetName, allocatedAmount: controller.getEntry()),
                CategoryType.essential,
              );

              Navigator.of(context).pop();
            }),
          ),
        ],
      ),
    );
  }
}
