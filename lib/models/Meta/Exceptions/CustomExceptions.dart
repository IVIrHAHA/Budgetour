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
