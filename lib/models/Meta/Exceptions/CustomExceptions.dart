class PartisanException implements Exception {
  final String message;

  const PartisanException([this.message]);

  String toString() {
    return message;
  }
}

class InvalidTransferException implements Exception {
  final String message;

  const InvalidTransferException([this.message]);

  String toString() {
    return message;
  }
}

class UndefinedStartingDateException implements Exception {
  final String message;

  const UndefinedStartingDateException([this.message]);

  String toString() {
    return message;
  }
}

class MultipleFrequenciesDefinedException implements Exception {
  final String message;

  const MultipleFrequenciesDefinedException([this.message]);

  String toString() {
    return message;
  }
}
