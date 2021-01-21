import 'package:budgetour/models/CashManager.dart';
import 'package:budgetour/models/Meta/QuickStat.dart';
import 'package:budgetour/models/finance_objects/FinanceObject.dart';
import 'package:budgetour/models/interfaces/RecurrenceMixin.dart';
import 'package:budgetour/models/interfaces/TransactionHistoryMixin.dart';
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
  not_ready,
  late_payment,
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
    with TransactionHistory, Recurrence {
  /// Recurring payment amount
  final double fixedPayment;

  bool _isPaid;
  bool _isReady;

  FixedPaymentObject({
    @required String name,
    @required this.fixedPayment,
    DateTime lastDueDate,
    DefinedOccurence definedOccurence,

    /// Make this versitile
  }) : super(name: name) {
    this.startingDate = lastDueDate ?? DateTime.now();
    this.frequency = definedOccurence;
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
  Transaction spendCash(double amount) {
    if (amount == fixedPayment) {
      _isPaid = true;
    } else {
      return null;
    }
    return super.spendCash(amount);
  }

  @override
  void transferReciept(Transaction transferReciept, CashHandler from) {
    /// Recieved amount needed to complete [fixedPayment]
    if ((transferReciept.amount + cashReserve) == fixedPayment) {
      _isReady = true;
    }

    /// Somehow cashReserve went over fixedPayment
    else if ((transferReciept.amount + cashReserve) > fixedPayment) {
      /// Maybe return any excess back to [from]
      throw Exception('exceeded amount needed by $name');
    }
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
        return ColorGenerator.fromHex(GColors.neutralColor);
        break;

      case _Status.not_ready:
        return ColorGenerator.fromHex(GColors.warningColor);
        break;

      case _Status.late_payment:
        return ColorGenerator.fromHex(GColors.alertColor);
        break;

      default:
        throw UnimplementedError('Unhandled Case in $name');
    }
  }

  /// Splite status change between paid, idle, and not-ready into thirds,
  /// between beginning and ending pay period.
  _Status _getStatus() {
    List<Duration> list = _splitTime();

    if (name == 'Rent') {
      print(list[0].inDays.toString() + ' paid');
      print(list[1].inDays.toString() + ' idle');
      print(list[2].inDays.toString() + ' not ready');
    }
    // ready - filled but not paid
    if (_isReady && !_isPaid && !isDue) {
      return _Status.ready;
    }
    // late payment - unfilled and has gone passed due date
    else if (!_isPaid && !_isReady && isDue) {
      return _Status.late_payment;
    }
    // Determine Time frames
    else {
      List<Duration> timeFrames = _splitTime();
      if (_isPaid) {
        return _Status.paid;
      }
      // idle - unfilled, but has time
      else if (!_isReady && !_isPaid && !isDue) {
        return _Status.idle;
      }
      // not ready - unfilled and is almost due
      else if (!_isReady && !_isPaid) {
        return _Status.not_ready;
      }
    }
    // paid - paid on time
  }

  static const int _timeSplit = 3;

  /// List assignment values
  /// 0 = paid
  /// 1 = idle
  /// 2 = not-ready
  List<Duration> _splitTime() {
    Duration period = nextOccurence.difference(startingDate);
    Duration timeLeft = DateTime.now().difference(startingDate);

    int registeredDays = period.inDays - timeLeft.inDays;

    int equalizingDays = period.inDays % _timeSplit;

    int cycles = 0;
    int days = period.inDays ~/ _timeSplit;

    List<int> dayList = [days, days, days];
    int i = 0;
    for (i = 0; registeredDays > days; i++) {
      dayList[i] = 0;
      registeredDays = registeredDays - days;
    }

    dayList[i] = days - registeredDays;


    // Split evenly
    if (equalizingDays == 0) {
      return <Duration>[
        Duration(days: dayList[0]), // paid
        Duration(days: dayList[1]), // idle
        Duration(days: dayList[2]) // not-ready
      ];
    }

    // add leftOverDay to idle
    else if (equalizingDays == 1) {
      return <Duration>[
        Duration(days: dayList[0]), // paid
        Duration(days: dayList[1]), // idle
        Duration(days: dayList[2]) // not-ready
      ];
    }

    // add leftOverDays to paid and (not-ready or idle)
    else if (equalizingDays == 2) {
      return <Duration>[
        Duration(days: cycles < 1 ? days - registeredDays : 0), // paid
        Duration(days: cycles < 2 ? days - registeredDays : 0), // idle
        Duration(days: cycles < 3 ? days - registeredDays : 0) // not-ready
      ];
    } else {
      throw Exception('failed splitting days');
    }
  }

  @override
  Text getAffirmation() {
    return null;
  }
}
