import 'package:budgetour/widgets/standardized/NameInputBox.dart';

import '../models/CategoryListManager.dart';
import '../models/finance_objects/BudgetObject.dart';
import '../tools/GlobalValues.dart';
import '../widgets/standardized/CalculatorView.dart';
import '../widgets/standardized/EnteredHeader.dart';
import '../widgets/standardized/InfoTile.dart';
import '../widgets/standardized/CalculatorInputDisplay.dart';
import 'package:common_tools/ColorGenerator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateBudgetPage extends StatefulWidget {
  final CategoryType targetCategory;

  CreateBudgetPage(this.targetCategory);

  @override
  _CreateBudgetPageState createState() => _CreateBudgetPageState();
}

class _CreateBudgetPageState extends State<CreateBudgetPage>
    with SingleTickerProviderStateMixin {
  /// [_theBudgetObject] the [BudgetObject] to be created
  /// needed as an instance variable because labels need to
  /// be added after the fact.
  BudgetObject _theBudgetObject;

  /// Controllers
  CalculatorController _calcController;
  AnimationController _animHeaderCtrl;

  /// [_budgetName] recorded upon pop-up dialog onEnterPressed
  String _budgetName;

  /// Color animation when [_budgetName] was not entered
  /// transmitted through [headerColor]
  Animation<Color> headerColorTween;
  Color headerColor = Colors.black;

  double _calcValue;
  Color numberColor = Colors.black;

  @override
  void initState() {
    _calcController = CalculatorController();
    _animHeaderCtrl = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 250,
      ),
    );

    /// Instantiating [headerColor] color animation
    headerColorTween = ColorTween(begin: Colors.black, end: Colors.red)
        .animate(_animHeaderCtrl)
          ..addListener(() {
            setState(() {
              if (_budgetName == null) headerColor = headerColorTween.value;

              if (_calcValue == null) numberColor = headerColorTween.value;
            });
          });

    super.initState();
  }

  @override
  void dispose() {
    _calcController.dispose();
    _animHeaderCtrl.dispose();
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
            flex: 6,
            child: _buildPromptContent(context),
          ),
          Flexible(
            flex: 0, // Use CalculatorView default height
            child: CalculatorView(
              MediaQuery.of(context).size.height / 2,
              controller: _calcController,
              onEnterPressed: (amount) {
                _onEnterPressed(amount);
              },
            ),
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
          CalculatorInputDisplay(
            controller: _calcController,
            textColor: numberColor,
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
    _calcValue = amount;
    // OnEnterPressed
    if (_calcValue != null && _budgetName != null) {
      _theBudgetObject = BudgetObject(
        title: _budgetName,
        categoryType: widget.targetCategory,
        targetAlloctionAmount: _calcController.getEntry(),
        stat1: _selectedStat1,
        stat2: _selectedStat2,
      );

      CategoryListManager.instance.add(
        _theBudgetObject,
        widget.targetCategory,
      );

      Navigator.of(context).pop();
    } else {
      _animHeaderCtrl.forward().whenComplete(() => _animHeaderCtrl.reverse());
    }
  }

  double _toolBarHeight;
  /// BUILD_APP_BAR METHOD
  /// ------------------------------------------
  /// builds the appBar used.
  /// This is a clone of [MyAppBarView], but has
  /// subtle changes.
  /// ------------------------------------------
  AppBar _buildAppBar(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    _toolBarHeight = MediaQuery.of(context).size.height * GlobalValues.creationAppBarHeightRatio;
    return AppBar(
      title: NameInputBox(
        defaultWidth: MediaQuery.of(context).size.width / 3,
        title: Text(_budgetName ?? 'Enter Name'),
        errorMessage: 'invalid',
        inputHint: 'Enter New Name',
        backgroundColor: headerColor,
        isValidFunction: (testTxt) {
          if (testTxt.isNotEmpty && testTxt != 'Enter Name') {
            return true;
          } else
            return false;
        },
        onSubmitted: (text) {
          _budgetName = text;
        },
      ),
      actions: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSelection(
              hint: 'Stat1',
              selection: _selectedStat1,
              onSelected: (newValue) => _selectedStat1 = newValue,
            ),
            _buildSelection(
              hint: 'Stat2',
              selection: _selectedStat2,
              onSelected: (newValue) => _selectedStat2 = newValue,
            ),
          ],
        ),
      ],
      toolbarHeight: _toolBarHeight,
    );
  }

  Widget _buildSelection(
      {String hint, var selection, Function(BudgetStat) onSelected}) {
    return Container(
      height: _toolBarHeight * .3,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: ColorGenerator.fromHex(GColors.borderColor),
          width: 1,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(
          GlobalValues.roundedEdges,
        ),
      ),
      child: DropdownButton<BudgetStat>(
        underline: Container(),
        style: TextStyle(color: Colors.grey),
        value: selection,
        hint: Text(
          hint,
          style: TextStyle(color: Colors.white),
        ),
        icon: Icon(Icons.arrow_drop_down),
        onChanged: (newValue) {
          /// should work as pointer?
          setState(() {
            onSelected(newValue);
          });
        },
        items: BudgetStat.values.map<DropdownMenuItem<BudgetStat>>((stat) {
          return DropdownMenuItem<BudgetStat>(
            value: stat,
            child: Text(stat.toString().split('.').last),
          );
        }).toList(),
      ),
    );
  }

  var _selectedStat1, _selectedStat2;
}
