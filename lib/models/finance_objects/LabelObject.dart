class LabelObject {
  final String title;
  final Future<double> valueFunction;

  const LabelObject(this.title, this.valueFunction);
}

abstract class PreDefinedLabels {
  static final LabelObject _allocationAmount = LabelObject('Allocated', _defineAllocationAmount());

  static Future<double> _defineAllocationAmount() async {
    print('from allo');
    return 0.0;
  }

  static get allocationAmount => _allocationAmount;
}