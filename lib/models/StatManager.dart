import 'finance_objects/BudgetObject.dart';

enum BudgetStat {
  allocated,
  remaining,
  spent,
}

class QuickStatBundle<FinanceObject> {
  final String request1;
  final String request2;

  QuickStat _quickStat1;
  QuickStat _quickStat2;

  final FinanceObject aObj;

  QuickStatBundle(this.aObj, {this.request1, this.request2}) {
    /// Create [QuickStatBundle] for a [BudgetObject]
    if (this.aObj is BudgetObject) {
      if (request1 != null)
        this._quickStat1 = _budgetQuickStat((aObj as BudgetObject), request1);

      if (request2 != null)
        this._quickStat2 = _budgetQuickStat((aObj as BudgetObject), request2);
    }
  }

  _budgetQuickStat(BudgetObject obj, String request) {
    /// Derive [BudgetStat] from request
    /// ** Make it easier to determine what you are trying to create
    BudgetStat stat = BudgetObject.preDefinedStats.keys.firstWhere(
        (element) => BudgetObject.preDefinedStats[element] == request);

    switch (stat) {
      case BudgetStat.allocated:
        return QuickStat(title: request, value: obj.allocatedAmount);
        break;
      case BudgetStat.remaining:
        // TODO: Handle this case.
        break;
      case BudgetStat.spent:
        return QuickStat(
            title: request,
            evaluateValue: Future<double>(obj.getMonthlyExpenses));
        break;
    }
  }

  QuickStat get stat1 => _quickStat1;
  QuickStat get stat2 => _quickStat2;
}

class QuickStat {
  final String title;
  final double value;

  final Future evaluateValue;

  QuickStat({this.title, this.value, this.evaluateValue});

  hasToEvaluate() {
    return evaluateValue != null;
  }
}