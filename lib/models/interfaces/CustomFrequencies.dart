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

  /// Could be enum or custom amount of days
  DefinedFrequencies frequency;
  Duration customFrequency;

  get nextOccurance => _determineNextOccurence();

  DateTime _determineNextOccurence() {
    if (startingDate != null) {
      var duratedFreq = _getFrequency();

      if (duratedFreq is DefinedFrequencies) {
        _handlePredefined(duratedFreq);
      } else if (duratedFreq is Duration) {
        _handleDuration(duratedFreq);
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

  void _handleDuration(Duration duration) {
    this._nextOccurence = startingDate.add(duration);
  }

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
