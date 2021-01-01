import '../models/CategoryListManager.dart';
import '../models/finance_objects/BudgetObject.dart';
import '../tools/DialogBox.dart';
import '../tools/GlobalValues.dart';
import '../widgets/standardized/CalculatorView.dart';
import '../widgets/standardized/EnteredHeader.dart';
import '../widgets/standardized/InfoTile.dart';
import '../widgets/standardized/InputDisplay.dart';
import 'package:common_tools/ColorGenerator.dart';
import 'package:flutter/material.dart';

class CreateBudgetPage extends StatefulWidget {
  final CategoryType targetedCategory;

  CreateBudgetPage(this.targetedCategory);

  @override
  _CreateBudgetPageState createState() => _CreateBudgetPageState();
}

class _CreateBudgetPageState extends State<CreateBudgetPage>
    with SingleTickerProviderStateMixin {
  CalculatorController _calcController;
  TextEditingController _textInputController;
  AnimationController _animController;

  String budgetName;

  Animation<Color> colorTween;

  Color headerColor = Colors.black;

  @override
  void initState() {
    _calcController = CalculatorController();
    _textInputController = TextEditingController();
    _animController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 250,
      ),
    );

    colorTween = ColorTween(begin: Colors.black, end: Colors.red)
        .animate(_animController)
          ..addListener(() {
            setState(() {
              headerColor =
                  budgetName == null ? colorTween.value : Colors.black;
            });
          });
    super.initState();
  }

  @override
  void dispose() {
    _calcController.dispose();
    _textInputController.dispose();
    super.dispose();
  }

  /// Enter Name pop-up
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
          color: headerColor,
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
                    controller: _calcController,
                    //indicatorColor: inputColor,
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 0, // Use CalculatorView default height
            child: CalculatorView(_calcController, (amount) {
              // OnEnterPressed
              if (amount != null && budgetName != null) {
                CategoryListManager.instance.add(
                  BudgetObject(
                    title: budgetName,
                    allocatedAmount: _calcController.getEntry(),
                  ),
                  widget.targetedCategory,
                );

                Navigator.of(context).pop();
              } else if (budgetName == null) {
                _animController
                    .forward()
                    .whenComplete(() => _animController.reverse());
              }
            }),
          ),
        ],
      ),
    );
  }
}
