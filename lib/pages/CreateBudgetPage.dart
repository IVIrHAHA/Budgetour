import 'package:budgetour/tools/NameInputBox.dart';

import '../models/CategoryListManager.dart';
import '../models/finance_objects/BudgetObject.dart';
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
  /// Controllers
  CalculatorController _calcController;
  TextEditingController _textInputController;
  AnimationController _animController;

  /// [budgetName] recorded upon pop-up dialog onEnterPressed
  String budgetName;

  /// Color animation when [budgetName] was not entered
  /// transmitted through [headerColor]
  Animation<Color> headerColorTween;
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

    /// Instantiating [headerColor] color animation
    headerColorTween = ColorTween(begin: Colors.black, end: Colors.red)
        .animate(_animController)
          ..addListener(() {
            setState(() {
              headerColor =
                  budgetName == null ? headerColorTween.value : Colors.black;
            });
          });
    super.initState();
  }

  @override
  void dispose() {
    _calcController.dispose();
    _textInputController.dispose();
    _animController.dispose();
    super.dispose();
  }

  /// MAIN_BUILD_FUNCTION
  /// ---------------------------------------------
  /// Creates prompt content to obtain user data
  /// ---------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: _buildAppBar(context),
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
            child: _buildPromptContent(context),
          ),
          Flexible(
            flex: 0, // Use CalculatorView default height
            child: CalculatorView(_calcController, (amount) {
              _onEnterPressed(amount);
            }),
          ),
        ],
      ),
    );
  }

  /// BUILD_PROMPT_CONTENT
  /// ---------------------------------------------
  /// Creates prompt content to obtain user data
  /// ---------------------------------------------
  Container _buildPromptContent(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: GlobalValues.defaultMargin),
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
            indicatorColor: ColorGenerator.fromHex(GColors.blueish),
          ),
        ],
      ),
    );
  }

  /// ON_ENTER_PRESSED
  /// ---------------------------------------------
  /// When user is ready to create [BudgetObject]
  /// Validate data entered
  /// ---------------------------------------------
  void _onEnterPressed(double amount) {
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
      _animController.forward().whenComplete(() => _animController.reverse());
    }
  }

  /// BUILD_APP_BAR METHOD
  /// ------------------------------------------
  /// builds the appBar used.
  /// This is a clone of [MyAppBarView], but has
  /// subtle changes.
  /// ------------------------------------------
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: ListTile(
        leading: NameInputBox(
          defaultWidth: MediaQuery.of(context).size.width / 3,
          title: Text(budgetName ?? 'Enter Name'),
          inputHint: 'Enter New Name',
          backgroundColor: headerColor,
          isValidFunction: (testTxt) {
            if (testTxt.isNotEmpty && testTxt != 'Enter Name') {
              return true;
            } else
              return false;
          },
          onSubmitted: (text) {
            budgetName = text;
          },
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
  }
}
