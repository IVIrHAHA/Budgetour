class LabelObject {
  final String title;
  final double value;

  final Future<double> evaluateValue;

  const LabelObject(this.title, {this.evaluateValue, this.value = 0});
}

abstract class PreDefinedLabels {
    static Future<double> _defineRemainingAmount() async {
    double amount = -950;

    for(int i = 0; i<100; i++) {
      amount += i;
    }

    return amount;
  }

  static allocationAmount(double amount) {
    return LabelObject('Allocated', value: amount);
  }
}