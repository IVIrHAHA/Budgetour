import 'package:budgetour/models/finance_objects/FinanceObject.dart';
import 'package:budgetour/models/finance_objects/FixedPaymentObject.dart';

import 'BudgetObject.dart';

class LabelObject {
  final String title;
  double value;

  final Future<double> evaluateValue;

  LabelObject({
    this.title = '',
    this.value = 0,
    this.evaluateValue,
  });

  void evaluate(Function(double val) whenDone) {
    if (hasToEvaluate()) {
      evaluateValue.then((value) {
        whenDone(value);
      }, onError: (_) {
        print('failed');
      });
    }
  }

  hasToEvaluate() {
    return evaluateValue != null;
  }
}

enum BudgetLabels {
  allocated,
  remaining,
  total_spent,
}

class PreDefinedLabels {
  final FinanceObject financeObject;

  const PreDefinedLabels(this.financeObject);

  // static Future<double> _defineRemainingAmount() async {
  //   double amount = -950;

  //   for (int i = 0; i < 100; i++) {
  //     amount += i;
  //   }

  //   return amount;
  // }

  allocationAmount(double amount) {
    return LabelObject(title: 'Allocated', value: amount);
  }

  LabelObject getLabel(dynamic request) {
    if (financeObject is BudgetObject) {
      return _getBudgetLabel(request, financeObject);
    }

    return null;
  }

  LabelObject _getBudgetLabel(BudgetLabels labelRequest, BudgetObject obj) {
    switch (labelRequest) {
      case BudgetLabels.allocated:
        return LabelObject(title: 'Allocated', value: obj.allocatedAmount);
        break;
      case BudgetLabels.remaining:
        return LabelObject(
            title: 'Remaining', evaluateValue: Future(obj.getMonthlyExpenses));
        break;
      case BudgetLabels.total_spent:
        // TODO: Handle this case.
        break;
    }
  }
}
