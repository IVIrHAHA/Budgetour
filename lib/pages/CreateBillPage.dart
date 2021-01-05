import 'package:budgetour/models/CategoryListManager.dart';
import 'package:budgetour/tools/GlobalValues.dart';
import 'package:budgetour/tools/NameInputBox.dart';
import 'package:budgetour/widgets/standardized/CalculatorView.dart';
import 'package:budgetour/widgets/standardized/EnteredHeader.dart';
import 'package:budgetour/widgets/standardized/CalculatorInputDisplay.dart';
import 'package:common_tools/ColorGenerator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:keyboard_actions/keyboard_actions_config.dart';

class CreateBillPage extends StatefulWidget {
  final CategoryType targetCategory;

  CreateBillPage(this.targetCategory);

  @override
  _CreateBillPageState createState() => _CreateBillPageState();
}

class _CreateBillPageState extends State<CreateBillPage>
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

  final FocusNode _focusNumber = FocusNode();
  final _keyboardNotifier = ValueNotifier<String>('0');

  KeyboardActionsConfig _builConfig(BuildContext ctx) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      keyboardSeparatorColor: Colors.amber,
      actions: [   
        KeyboardActionsItem(
          focusNode: _focusNumber,
          displayActionBar: false,
          enabled: false,
          footerBuilder: (ctx) {
            return CalculatorView(
              MediaQuery.of(context).size.height / 2,
              notifier: _keyboardNotifier,
              controller: _calcController,
              onEnterPressed: (_) {
                print('enter accepted');
              },
            );
          },
        ),
      ],
    );
  }

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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32.0),
                      child: KeyboardActions(
                        disableScroll: true,
                        tapOutsideToDismiss: true,
                        config: _builConfig(context),
                        child: KeyboardCustomInput<String>(
                          focusNode: _focusNumber,
                          notifier: _keyboardNotifier,
                          builder: (ctx, _, focus) {
                            return _buildQuestion(
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
                  ),

                  // Payment Due-Date
                  Flexible(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32.0),
                      child: _buildQuestion(
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
                                  suffixIcon: Icon(Icons.calendar_today,
                                      color: Colors.blue)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Frequency',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              DropdownButton<String>(
                                value: 'Monthly',
                                icon: Icon(Icons.arrow_drop_down),
                                onChanged: (newValue) {
                                  print('changed from menu: ' + newValue);
                                },
                                items: <String>[
                                  'Weekly',
                                  'Monthly',
                                  'Bi-Monthly',
                                  'Yearly'
                                ].map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
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
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextEditingController startdata = new TextEditingController();
  DateTime selectedDate = DateTime.now();
  var myFormat = DateFormat('yyyy-MM-dd');
  Future selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: selectedDate,
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.amber,
            accentColor: Colors.amberAccent,
            colorScheme: ColorScheme.light(primary: Colors.amber),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child,
        );
      },
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        startdata = TextEditingController(
          text: myFormat.format(picked),
        );
      });
    } else {}
  }

  /// BUILD_PROMPT_CONTENT
  /// ---------------------------------------------
  /// Creates prompt content to obtain user data
  /// ---------------------------------------------
  Widget _buildQuestion(
    BuildContext context, {
    String title,
    Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
