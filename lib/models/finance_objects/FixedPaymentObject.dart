import 'package:budgetour/models/BudgetourReserve.dart';
import 'package:budgetour/models/CategoryListManager.dart';
import 'package:budgetour/models/Meta/QuickStat.dart';
import 'package:budgetour/models/finance_objects/FinanceObject.dart';
import 'package:budgetour/models/interfaces/RecurrenceMixin.dart';
import 'package:budgetour/routes/FixedPaymentObj_route.dart';
import 'package:budgetour/tools/GlobalValues.dart';
import 'package:common_tools/ColorGenerator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum FixedPaymentStats {
  monthlyPayment,
  nextDue,
  supplied,
}

enum _Status {
  idle,
  paid,
  ready,
  ready_set_as_manual,
  not_ready,
  late_payment,
  late_set_as_manual,
}

/// FixedPayment what to convey to user
/// - idle
///   not filled but has time before due date
///
/// - Paid
///   mark as green, paid
///
/// - Filled and awaiting payment
///   leave nuetral and set as ready No action required
///   automatically process payment
///
/// - Not filled and payment is coming
///   make yellow and set needs allocation of resources
///
/// - Not filled and late
///   make red and set as late. Make payment, Action Required

class FixedPaymentObject extends FinanceObject<FixedPaymentStats>
    with Recurrence {
  /// Recurring payment amount
  double fixedPayment;

  /// This gets set as true when spendCash is equal to fixedPayment
  /// Gets set as false when _isReady is set as true during [transferReciept]
  /// Also, set to false when its Duration is up, in [_splitTime]
  bool _isPaid;

  /// Is set true only during [transferReciept]
  /// Set false only during [spendCash]
  bool _isReady;

  bool markAsAutoPay;

  FixedPaymentObject({
    @required String name,
    @required this.fixedPayment,
    @required CategoryType categoryType,
    this.markAsAutoPay = false,
    DateTime lastDueDate,
    DefinedOccurence definedOccurence,
  }) : super(
          name: name,
          categoryIndex: CategoryType.values.indexOf(categoryType),
        ) {
    this.startingDate = lastDueDate ?? DateTime.now();
    this.recurrence = definedOccurence ?? DefinedOccurence.monthly;
    this._isPaid = false;
    this._isReady = false;
  }

  bool get isPaid => _isPaid;

  @override
  Widget getLandingPage() {
    return FixedPaymentObjRoute(this);
  }

  @override
  QuickStat determineStat(statType) {
    switch (statType) {
      case FixedPaymentStats.monthlyPayment:
        return QuickStat(title: 'Payment Amount', value: fixedPayment);
        break;
      case FixedPaymentStats.nextDue:
        return QuickStat(
          title: 'Due',
          evaluateValue: Future<String>(() {
            return DateFormat('M/d').format(nextOccurence);
          }),
        );
        break;
      case FixedPaymentStats.supplied:
        return QuickStat(title: 'Supplied', value: cashReserve);
        break;
    }
    return null;
  }

  @override
  Future<Transaction> spendCash(double amount) {
    if (amount == fixedPayment) {
      _isPaid = true;
      _isReady = false;
      notifyDates();
    } else {
      return null;
    }
    return super.spendCash(amount);
  }

  @override
  transferReciept(Future<Transaction> transferReciept, CashHandler from) {
    /// Recieved amount needed to complete [fixedPayment]
    if (cashReserve == fixedPayment) {
      _isReady = true;
      _isPaid = false;
    }
    return transferReciept;
  }

  @override
  bool acceptTransfer(double amount) {
    /// Ensure cashReserve never exceeds fixedPayment
    if ((amount + cashReserve) <= fixedPayment) {
      return true;
    } else
      return false;
  }

  @override
  double suggestedTransferAmount() {
    return fixedPayment - cashReserve;
  }

  @override
  Color getTileColor() {
    switch (_getStatus()) {
      case _Status.idle:
        return ColorGenerator.fromHex(GColors.neutralColor);
        break;

      case _Status.paid:
        return ColorGenerator.fromHex(GColors.positiveColor);
        break;

      case _Status.ready:
        return ColorGenerator.fromHex(GColors.positiveColor);
        break;

      case _Status.ready_set_as_manual:
        return ColorGenerator.fromHex(GColors.neutralColor);
        break;

      case _Status.not_ready:
        return ColorGenerator.fromHex(GColors.warningColor);
        break;

      case _Status.late_payment:
        return ColorGenerator.fromHex(GColors.alertColor);
        break;
      case _Status.late_set_as_manual:
        return ColorGenerator.fromHex(GColors.alertColor);
        break;
    }
    throw UnimplementedError('Unhandled Case in $name');
  }

  _runUpdate() {
    if (markAsAutoPay && _isReady && !_isPaid && isDue) {
      if (this.spendCash(this.cashReserve) != null) notifyDates();
    }
    // Reset if paid and is due
    else if (_isPaid && isDue) {
      notifyDates();
    }
  }

  /// Splite status change between paid, idle, and not-ready into thirds,
  /// between beginning and ending pay period.
  _Status _getStatus() {
    // ready - filled but not paid
    if (_isReady && !_isPaid && !isDue && markAsAutoPay) {
      return _Status.ready;
    } else if (_isReady && !_isPaid && !isDue && !markAsAutoPay) {
      return _Status.ready_set_as_manual;
    }
    // late payment - unfilled and has gone passed due date
    else if (!_isPaid && !_isReady && isDue) {
      return _Status.late_payment;
    }

    /// Ready but forgot to make payment
    else if (!_isPaid && _isReady && isDue && !markAsAutoPay) {
      return _Status.late_set_as_manual;
    }
    // Determine Time frames
    else {
      List<Duration> timeFrames = _splitTime();
      // paid - paid on time
      if (_isPaid || timeFrames[0].inDays != 0 && !_isReady && _isPaid) {
        return _Status.paid;
      }
      // idle - unfilled, but has time
      else if (!_isReady && !_isPaid && !isDue && timeFrames[1].inDays != 0) {
        return _Status.idle;
      }
      // not ready - unfilled and is almost due
      else if (!_isReady && !_isPaid && timeFrames[2].inDays != 0) {
        return _Status.not_ready;
      }
    }
    throw UnimplementedError('unforeseen case occurred in $name');
  }

  static const int _timeSplit = 3;

  /// List assignment values
  /// 0 = paid
  /// 1 = idle
  /// 2 = not-ready
  List<Duration> _splitTime() {
    /// Get the entire pay-period
    Duration period = nextOccurence.difference(startingDate);

    /// Get time left until next due-date
    Duration timeLeft = nextOccurence.difference(DateTime.now());

    /// Track uneven day count (these days will be appended to 'not-ready')
    /// Example: January has 31 days, so this result will be 1
    int equalizingDays = period.inDays % _timeSplit;

    /// Marks how far along this FixedPaymentObject is on its pay-period
    int xDays = period.inDays - timeLeft.inDays;

    /// Actual amount of days dictated by [_timeSplit].
    int timeChunk = period.inDays ~/ _timeSplit;

    List<int> dayList = [timeChunk, timeChunk, timeChunk];
    int i = 0;

    for (i = 0; xDays > timeChunk && i < dayList.length - 1; i++) {
      dayList[i] = 0; // For every chunk removed, mark the dayChunk as used up
      xDays = xDays - timeChunk; // Chunk away xDays
    }

    dayList[i] = timeChunk - xDays; // Use up remaining xDays

    /// set _isPaid to false if time is up
    if (dayList[0] == 0 && _isPaid) {
      _isPaid = false;
    }

    return <Duration>[
      Duration(days: dayList[0]), // paid
      Duration(days: dayList[1]), // idle
      Duration(days: dayList[2] + equalizingDays) // not-ready
    ];
  }

  @override
  Text getAffirmation() {
    /// Set here because this gets called first
    _runUpdate();
    switch (_getStatus()) {
      case _Status.idle:
        return _affirmText('idle');
        break;
      case _Status.paid:
        return _affirmText('paid',
            color: ColorGenerator.fromHex(GColors.greenish));
        break;
      case _Status.ready:
        return _affirmText('ready, no further action required');
        break;
      case _Status.not_ready:
        return _affirmText('not ready');
        break;
      case _Status.late_payment:
        return _affirmText('late payment');
        break;
      case _Status.late_set_as_manual:
        return _affirmText('It\'s ready but forgetting to pay');
        break;
      case _Status.ready_set_as_manual:
        return _affirmText('ready to pay, when you choose');
        break;
    }
    throw UnimplementedError('Unforeseen error in $name');
  }

  Text _affirmText(String text, {Color color = Colors.grey}) {
    return Text(
      text,
      style: TextStyle(color: color),
      softWrap: false,
      overflow: TextOverflow.fade,
    );
  }

  /* --------------------------------------------------------------------------------------------
   *  PERSISTENCE METHODS
   * --------------------------------------------------------------------------------------------
   */

  static const String _nameColumn = 'name';
  static const String _categoryColumn = 'categoryId';
  static const String _sDateColumn = 'starting_date';
  static const String _defOccurenceColumn = 'definedOccurence';
  static const String _stat1Column = 'stat1';
  static const String _stat2Column = 'stat2';
  // This specific
  static const String _fixedPaymentColumn = 'fixed_payment';
  static const String _markedAsAutoPayColumn = 'auto_pay';
  static const String _markedAsReadyColumn = 'is_ready';
  static const String _isPaidColumn = 'is_paid';

  @override
  double get transactionLink => null;

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonMap = {
      _nameColumn: this.name,
      _categoryColumn: this.categoryIndex,
      _sDateColumn: this.startingDate.millisecondsSinceEpoch,
      _defOccurenceColumn: getOccurenceJson(),
      _stat1Column: this.firstStat.toString(),
      _stat2Column: this.secondStat.toString(),
      _fixedPaymentColumn: this.fixedPayment,
      _markedAsAutoPayColumn: this.markAsAutoPay ? 1 : 0,
      _markedAsReadyColumn: this._isReady ? 1 : 0,
      _isPaidColumn: this._isPaid ? 1 : 0,
    };
    return jsonMap;
  }

  FixedPaymentObject.fromJson(Map map)
      : super(
          name: map[_nameColumn],
          categoryIndex: map[_categoryColumn],
        ) {
    this.startingDate = DateTime.fromMillisecondsSinceEpoch(map[_sDateColumn]);
    this.recurrence = occurenceEnumFromString(map[_defOccurenceColumn]);
    this.firstStat =
        statEnumFromString(FixedPaymentStats.values, map[_stat1Column]);
    this.secondStat =
        statEnumFromString(FixedPaymentStats.values, map[_stat2Column]);
    this.fixedPayment = map[_fixedPaymentColumn];
    this.markAsAutoPay = map[_markedAsAutoPayColumn] == 1 ? true : false;
    this._isReady = map[_markedAsReadyColumn] == 1 ? true : false;
    this._isPaid = map[_isPaidColumn] == 1 ? true : false;
  }
}
