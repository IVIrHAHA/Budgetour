import 'package:budgetour/models/Meta/Exceptions/CustomExceptions.dart';

enum DefinedOccurence {
  yearly,
  semi_yearly,
  monthly,
  bi_weekly,
  weekly,
}

/// How to use
/// 1. set [startingDate]
/// 2. Give **either** [frequency] or [customFrequency], using [DefinedOccurence] 
///     or [Duration] respectfully.
/// 3. [nextOccurence] will give you next occurence or will update nextOccurence if 
///     needed.
/// 4. Use [nofityDates] to update both [startingDate] and [nextOccurence] when 
///     [isDue] == true

mixin Recurrence {
  DateTime startingDate;
  DateTime _nextOccurence;

  /// Sets [nextOccurence] with respect to a fixed due-day.
  /// Taking into account the variance of days in a month.
  ///
  /// Example: Monthly? Due Date = Jan. 16th, [nextOccurence] = Feb. 16th
  DefinedOccurence frequency;

  /// Sets [nextOccurence] with disregard of due-day.
  Duration customFrequency;

  notifyDates() {
    /// set startingDate as current _nextOccurence
    this.startingDate = this._nextOccurence ?? _determineNextOccurence();

    /// Make _nextOccurence null
    this._nextOccurence = null;

    /// determine _nextOccurence
    _determineNextOccurence();
  }

  bool get isDue => DateTime.now().isAfter(this.nextOccurence ?? _determineNextOccurence());

  get nextOccurence => _determineNextOccurence();

  /// Sets [_nextOccurence] if needed. Otherwise, returns [_nextOccurence].
  DateTime _determineNextOccurence() {
    /// _nextOccurence is already set and up to date
    if (startingDate != null && this._nextOccurence != null) {
      return this._nextOccurence;
    }

    /// _nextOccurence needs to be set or updated
    else if (startingDate != null && this._nextOccurence == null) {
      var duratedFreq = _getFrequency();

      if (duratedFreq is DefinedOccurence) {
        _handlePredefined(duratedFreq);
      } else if (duratedFreq is Duration) {
        this._nextOccurence = startingDate.add(duratedFreq);
      }

      // This should never be called
      else {
        throw Exception('Unable to handle defined Frequency');
      }

      return this._nextOccurence;
    } else {
      throw UndefinedStartingDateException('startingDate is undefined');
    }
  }

  /// This sets [nextOccurence] with respect to a fixed due-day.
  /// Taking into account the variance of days in a month.
  ///
  /// Example: Monthly? Due Date = Jan. 16th, [nextOccurence] = Feb. 16th
  void _handlePredefined(DefinedOccurence frequency) {
    switch (frequency) {
      case DefinedOccurence.yearly:
        // TODO: Handle this case.
        break;
      case DefinedOccurence.semi_yearly:
        // TODO: Handle this case.
        break;

      case DefinedOccurence.monthly:
        // ensure date doesn't have to rollover year
        if (startingDate.month < 12) {
          this._nextOccurence = DateTime(
            startingDate.year,
            startingDate.month + 1,
            startingDate.day,
            0,
            0,
          );
        }

        // rollover year as well
        else {
          this._nextOccurence = DateTime(
            startingDate.year + 1,
            1,
            startingDate.day,
            0,
            0,
          );
        }
        break;

      case DefinedOccurence.bi_weekly:
        // TODO: Handle this case.
        break;
      case DefinedOccurence.weekly:
        // TODO: Handle this case.
        break;
    }
  }

  /// Interprets the Frequency set by dev/user.
  /// Ensure only one has been defined.
  _getFrequency() {
    if (frequency != null && customFrequency == null) {
      return this.frequency;
    } else if (customFrequency != null && frequency == null) {
      return this.customFrequency;
    } else {
      throw MultipleFrequenciesDefinedException(
          'Multiple Frequencies were defined');
    }
  }
}
