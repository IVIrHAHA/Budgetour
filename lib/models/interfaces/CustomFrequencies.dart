import 'package:budgetour/models/Meta/Exceptions/CustomExceptions.dart';

enum DefinedFrequencies {
  yearly,
  semi_yearly,
  monthly,
  bi_weekly,
  weekly,
}

mixin FrequencyOccurence {
  DateTime startingDate;
  DateTime _nextOccurence;

  /// Sets [nextOccurence] with respect to a fixed due-day.
  /// Taking into account the variance of days in a month.
  ///
  /// Example: Monthly? Due Date = Jan. 16th, [nextOccurance] = Feb. 16th
  DefinedFrequencies frequency;

  /// Sets [nextOccurence] with disregard of due-day.
  Duration customFrequency;

  /// TODO: Look into adding an observer to observe when the FinanceObject
  /// is ready to have _nextOccurance updated.

  bool get isDue => DateTime.now().isAfter(this.nextOccurance);

  get nextOccurance => _determineNextOccurence();

  /// Sets [_nextOccurence] if needed. Otherwise, returns [_nextOccurence].
  DateTime _determineNextOccurence() {
    if (startingDate != null && this._nextOccurence == null) {
      var duratedFreq = _getFrequency();

      if (duratedFreq is DefinedFrequencies) {
        _handlePredefined(duratedFreq);
      } else if (duratedFreq is Duration) {
        this._nextOccurence = startingDate.add(duratedFreq);
      }

      // This should never be called
      else {
        throw Exception('Unable to handle defined Frequency');
      }

      return this._nextOccurence;
    } else if (startingDate != null && nextOccurance != null) {
      return this.nextOccurance;
    } else {
      throw UndefinedStartingDateException('startingDate is undefined');
    }
  }

  /// This sets [nextOccurence] with respect to a fixed due-day.
  /// Taking into account the variance of days in a month.
  ///
  /// Example: Monthly? Due Date = Jan. 16th, [nextOccurance] = Feb. 16th
  void _handlePredefined(DefinedFrequencies frequency) {
    switch (frequency) {
      case DefinedFrequencies.yearly:
        // TODO: Handle this case.
        break;
      case DefinedFrequencies.semi_yearly:
        // TODO: Handle this case.
        break;

      case DefinedFrequencies.monthly:
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

      case DefinedFrequencies.bi_weekly:
        // TODO: Handle this case.
        break;
      case DefinedFrequencies.weekly:
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
