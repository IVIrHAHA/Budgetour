import 'package:budgetour/models/CategoryListManager.dart';
import 'package:budgetour/models/finance_objects/FixedPaymentObject.dart';
import 'package:budgetour/models/interfaces/RecurrenceMixin.dart';
import 'package:budgetour/tools/GlobalValues.dart';
import 'package:budgetour/widgets/standardized/NameInputBox.dart';
import 'package:budgetour/widgets/standardized/CalculatorView.dart';
import 'package:budgetour/widgets/standardized/EnteredHeader.dart';
import 'package:budgetour/widgets/standardized/CalculatorInputDisplay.dart';
import 'package:common_tools/ColorGenerator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:keyboard_actions/keyboard_actions_config.dart';

class CreateFixedPaymentPage extends StatefulWidget {
  final CategoryType targetCategory;

  CreateFixedPaymentPage(this.targetCategory);

  @override
  _CreateFixedPaymentPageState createState() => _CreateFixedPaymentPageState();
}

class _CreateFixedPaymentPageState extends State<CreateFixedPaymentPage>
    with SingleTickerProviderStateMixin {
  /// Controllers
  CalculatorController _calcController;
  AnimationController _animHeaderCtrl;

  /// [_billName] recorded upon pop-up dialog onEnterPressed
  String _billName;

  /// Color animation when [_billName] was not entered
  /// transmitted through [headerColor]
  Animation<Color> headerColorTween;
  Color headerColor = Colors.black;

  double _calcValue;
  Color numberColor = Colors.black;

  Function _enterFunction;

  var _selectedFrequency = DefinedOccurence.monthly;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: _buildAppBar(context),
      body: Container(
        padding: const EdgeInsets.all(GlobalValues.defaultMargin),
        child: Column(
          children: [
            Expanded(
              flex: 0,
              child: EnteredHeader(
                text: 'Square',
                text2: ' Details',
                color: ColorGenerator.fromHex(GColors.blueish),
              ),
            ),

            // Questions Column
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Flexible(
                    flex: 3,
                    child: KeyboardActions(
                      disableScroll: true,
                      tapOutsideToDismiss: false,
                      config: _buildConfig(context),
                      child: KeyboardCustomInput<String>(
                        focusNode: _focusNumber,
                        notifier: _keyboardNotifier,
                        builder: (ctx, _, focus) {
                          return _formatQuestion(
                            context,
                            title: 'How much is the bill?',
                            child: CalculatorInputDisplay(
                              controller: _calcController,
                              textColor: numberColor,
                              indicatorColor: Colors.grey,
                              indicatorSize: 1,
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // Payment Due-Date
                  Flexible(
                    flex: 3,
                    child: _formatQuestion(
                      context,
                      title: 'When is the next payment due date?',
                      child: GestureDetector(
                        onTap: () {
                          selectDate(context);
                        },
                        child: AbsorbPointer(
                          absorbing: true,
                          child: TextFormField(
                            controller: startdata,
                            keyboardType: TextInputType.datetime,
                            decoration: InputDecoration(
                              hintText: DateFormat('MM-dd-yyyy')
                                  .format(_selectedDate),
                              suffixIcon: Icon(
                                Icons.calendar_today,
                                color: ColorGenerator.fromHex(GColors.blueish),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Select Frequency
                  Flexible(
                    flex: 3,
                    child: _selectFrequency(context),
                  ),
                ],
              ),
            ),
            MaterialButton(
              onPressed: _onEntryEntered,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(GlobalValues.roundedEdges),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 4,
              ),
              color: Colors.black,
              disabledColor: Colors.grey,
              child: Text(
                'Enter',
                style: Theme.of(context).textTheme.button.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _onEntryEntered() {
    if (_selectedDate != null &&
        _calcValue != null &&
        _selectedFrequency != null &&
        _billName != null) {
      // FixedPayment is valid and return to main screen
      _returnFixedPayment();
    }

    // Try to gather information and notify user what is missing
    else {
      _calcValue = _calcController.value;
      _animHeaderCtrl.forward().whenComplete(() => _animHeaderCtrl.reverse());
    }
  }

  bool _validEntries() {
    return true;
  }

  _returnFixedPayment() {
    if (_validEntries()) {
      CategoryListManager.instance.add(
        FixedPaymentObject(
          name: _billName,
          categoryID: widget.targetCategory.hashCode,
          fixedPayment: _calcValue,
          lastDueDate: DateTime(2020, 12, 1, 0, 0),

          /// TODO: EDIT THIS
          definedOccurence: _selectedFrequency,
        ),
        widget.targetCategory,
      );

      Navigator.of(context).pop();
    } else {
      _animHeaderCtrl.forward().whenComplete(() => _animHeaderCtrl.reverse());
    }
  }

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
              if (_billName == null) headerColor = headerColorTween.value;

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

  /// METHOD: SELECT FREQUENCY
  /// -------------------------------------------
  /// Get the frequency at which the [FixedPaymentObject]
  /// will be billed
  /// -------------------------------------------
  Widget _selectFrequency(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Frequency',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            DropdownButton<DefinedOccurence>(
              value: _selectedFrequency,
              icon: Icon(Icons.arrow_drop_down),
              onChanged: (newValue) {
                _selectedFrequency = newValue;
              },
              items: DefinedOccurence.values
                  .map<DropdownMenuItem<DefinedOccurence>>(
                      (DefinedOccurence value) {
                return DropdownMenuItem<DefinedOccurence>(
                  value: value,
                  child: Text(_convertEnumToString(value)),
                );
              }).toList(),
            ),
          ],
        ),
        Divider(
          color: Colors.grey,
          thickness: 1,
          height: 0,
        )
      ],
    );
  }

  String _convertEnumToString(DefinedOccurence evalue) {
    String string = evalue.toString().split('.').last.toString();

    // TODO: Revise non-working logic
    if (string.contains('_')) {
      string.replaceFirst('_', '-');
    }

    return string;
  }

  final FocusNode _focusNumber = FocusNode();

  /// As of now this is only used as a means to
  /// implement [CalculatorView] but it doesn't
  /// actually return anything
  final _keyboardNotifier = ValueNotifier<String>(null);

  /// METHOD: BUILD CONFIG
  /// --------------------------------------------------
  /// Configures [CalculatorView] as the system keyboard.
  /// Uses the [KeyboardActions] package to achieve this.
  ///
  /// ** Because there are multiple questions, the CalcView
  /// needs to appear/hide when answering other questions
  /// --------------------------------------------------
  KeyboardActionsConfig _buildConfig(BuildContext ctx) {
    /// [KeyboardActionsConfig] is used by [KeyboardActions]
    /// when building [CalculatorInputDisplay].
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      nextFocus: false,
      actions: [
        KeyboardActionsItem(
          focusNode: _focusNumber,
          displayActionBar: false, // Hides the action bar
          enabled: false,
          footerBuilder: (ctx) {
            return CalculatorView(
              MediaQuery.of(context).size.height / 2,
              notifier: _keyboardNotifier,
              controller: _calcController,
              onEnterPressed: (amount) {
                if (amount != null) {
                  _calcValue = amount;
                  _focusNumber.unfocus();
                }
              },
            );
          },
        ),
      ],
    );
  }

  /// METHOD: SELECT DATE
  /// -----------------------------------------------------
  /// Promps user to select a date from a calendar
  /// -----------------------------------------------------
  TextEditingController startdata = new TextEditingController();
  DateTime _selectedDate = DateTime.now();
  var myFormat = DateFormat('MM-dd-yyyy');
  Future selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: _selectedDate,
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.black,
            accentColor: Colors.amberAccent,
            colorScheme: ColorScheme.light(primary: Colors.black),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        startdata = TextEditingController(
          text: myFormat.format(picked),
        );
      });
    } else {}
  }

  /// METHOD: BUILD_QUESTION_FORMAT
  /// ---------------------------------------------
  /// Creates prompt content to obtain user data
  /// ---------------------------------------------
  Widget _formatQuestion(
    BuildContext context, {
    String title,
    Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        child,
      ],
    );
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
          title: Text(_billName ?? 'Enter Name'),
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
            _billName = text;
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
