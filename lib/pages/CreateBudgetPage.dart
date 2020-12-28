import 'package:budgetour/tools/GlobalValues.dart';
import 'package:budgetour/widgets/standardized/CalculatorView.dart';
import 'package:budgetour/widgets/standardized/EnteredHeader.dart';
import 'package:budgetour/widgets/standardized/EnteredInput.dart';
import 'package:common_tools/ColorGenerator.dart';
import 'package:flutter/material.dart';

class CreateBudgetPage extends StatefulWidget {
  @override
  _CreateBudgetPageState createState() => _CreateBudgetPageState();
}

class _CreateBudgetPageState extends State<CreateBudgetPage> {
  CalculatorController controller;
  String inputText = '0.00';

  @override
  void initState() {
    controller = CalculatorController();
    controller.addListener((formatedText) {
      setState(() {
        inputText = formatedText;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
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
              'Enter Name', // TODO: extrapolate
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
            fit: FlexFit.tight,
            child: Container(
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EnteredHeader(
                    text: 'Square',
                    text2: ' Details',
                    color: Colors.blue,
                  ),
                  Text('How much is going into this budget?'),
                  EnteredInput('\$ $inputText'),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 0,
            child: CalculatorView(controller, (_) {
              print('submit some data');
            }),
          ),
        ],
      ),
    );
  }
}
