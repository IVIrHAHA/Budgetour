import 'package:budgetour/models/Meta/Exceptions/CustomExceptions.dart';
import 'dart:convert';

enum DefinedOccurence {
  yearly,
  semi_yearly,
  monthly,
  bi_weekly,
  weekly,
}

/// How to use
/// 1. set [startingDate]
/// 2. Give **either** [_definedFrequency] or [_customFrequency], using [DefinedOccurence]
///     or [Duration] respectfully.
/// 3. [nextOccurence] will give you next occurence or will update nextOccurence if
///     needed.
/// 4. Use [nofityDates] to update both [startingDate] and [nextOccurence] when
///     [isDue] == true

mixin Recurrence {
  DateTime startingDate;
  DateTime _nextOccurence;

  /// If set as DefinedOccurence:
  /// Sets [nextOccurence] with respect to a fixed due-day.
  /// Taking into account the variance of days in a month.
  ///
  /// Example: Monthly? Due Date = Jan. 16th, [nextOccurence] = Feb. 16th
  ///
  /// If set as Duration:
  /// Sets [nextOccurence] with disregard of due-day.
  var recurrence;

  notifyDates() {
    /// set startingDate as current _nextOccurence
    this.startingDate = this._nextOccurence ?? _determineNextOccurence();

    /// Make _nextOccurence null
    this._nextOccurence = null;

    /// determine _nextOccurence
    _determineNextOccurence();
  }

  bool get isDue =>
      DateTime.now().isAfter(this.nextOccurence ?? _determineNextOccurence());

  DateTime get nextOccurence => _determineNextOccurence();

  /// Sets [_nextOccurence] if needed. Otherwise, returns [_nextOccurence].
  DateTime _determineNextOccurence() {
    /// _nextOccurence is already set and up to date
    if (startingDate != null && this._nextOccurence != null) {
      return this._nextOccurence;
    }

    /// _nextOccurence needs to be set or updated
    else if (startingDate != null && this._nextOccurence == null) {
      return _defineOccurence();
    } else {
      throw UndefinedStartingDateException('startingDate is undefined');
    }
  }

  /// This sets [nextOccurence] with respect to a fixed due-day.
  /// Taking into account the variance of days in a month.
  ///
  /// Example: Monthly? Due Date = Jan. 16th, [nextOccurence] = Feb. 16th
  DateTime _handlePredefined(DefinedOccurence frequency) {
    switch (frequency) {
      case DefinedOccurence.yearly:
        throw UnimplementedError('implement yearly frequency');
        break;
      case DefinedOccurence.semi_yearly:
        throw UnimplementedError('implement semi-yearly frequency');
        break;

      case DefinedOccurence.monthly:
        // ensure date doesn't have to rollover year
        if (startingDate.month < 12) {
          return DateTime(
            startingDate.year,
            startingDate.month + 1,
            startingDate.day,
            0,
            0,
          );
        }

        // rollover year as well
        else {
          return DateTime(
            startingDate.year + 1,
            1,
            startingDate.day,
            0,
            0,
          );
        }
        break;

      case DefinedOccurence.bi_weekly:
        throw UnimplementedError('implement bi-weekly frequency');
        break;
      case DefinedOccurence.weekly:
        throw UnimplementedError('implement weekly frequency');
        break;
    }
    throw Exception('Unhandled frequency');
  }

  /// Interprets the Frequency set by dev/user.
  _defineOccurence() {
    /// recurrence is of type DefinedOccurence
    if (this.recurrence is DefinedOccurence) {
      this._nextOccurence = _handlePredefined(this.recurrence);
    }

    /// recurrence is of type Duration
    else if (recurrence is Duration) {
      this._nextOccurence = startingDate.add(this.recurrence);
    } else {
      throw Exception('Unknown Recurrence type');
    }

    return this._nextOccurence;
  }

  /// Used to interpret and convert to json, when converting any object utilizing this interface
  dynamic getOccurenceJson() {
    if (recurrence is Duration) {
      return (recurrence as Duration).inMilliseconds;
    } else if (recurrence is DefinedOccurence) {
      return (recurrence as DefinedOccurence);
    } else
      return null;
  }

  // test() {
  //   /// How to store startingDate
  //   int startingDateQ = ((startingDate.millisecondsSinceEpoch) / 1000).round();

  //   DateTime tester =
  //       DateTime.fromMillisecondsSinceEpoch((startingDateQ * 1000).round());

  //   print('This is original startDate: $startingDate');
  //   print('This is tester DateTime: $tester');
  // }

  // Map<String, dynamic> toJson() {
  //   Map<String, dynamic> json = {
  //     'startDate': ((startingDate.millisecondsSinceEpoch) / 1000).round(),
  //     'duration':
  //         (recurrence is Duration) ? (recurrence as Duration).inSeconds : null,
  //     'defDuration': (recurrence is DefinedOccurence)
  //         ? (recurrence as DefinedOccurence).toString()
  //         : null,
  //   };

  //   return json;
  // }

  // String get json => jsonEncode(this);
}
