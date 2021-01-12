class QuickStat {
  final String title;
  final double value;

  final Future<String> evaluateValue;

  QuickStat({this.title, this.value, this.evaluateValue});

  hasToEvaluate() {
    return evaluateValue != null;
  }
}