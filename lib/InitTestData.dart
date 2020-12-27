import 'dart:math';

import 'package:budgetour/models/FixedPaymentObject.dart';

import './models/BudgetObject.dart';
import './models/FinanceObject.dart';
import './models/Transaction.dart';

class InitTestData {
  static final List<FinanceObject> dummyEssentialList = List<FinanceObject>();

  static initTileList() {
    dummyEssentialList.add(_buildBudgetObjects('Food', 150, 10));
    dummyEssentialList.add(_buildBudgetObjects('Gas', 135, 4));
    dummyEssentialList.add(_buildFixedPaymentObject('Rent', 578));

    return dummyEssentialList;
  }

  static BudgetObject _buildBudgetObjects(
      String title, double allocationAmount, int transactionQTY,) {

    BudgetObject obj =
        BudgetObject(title: title, allocatedAmount: allocationAmount);

    // Log random transactions
    for (int i = 0; i <= transactionQTY; i++) {
      obj.logTransaction(
        Transaction(
          description: 'Tran_${i+1}',
          amount: _doubleInRange(5, 25),
          date: DateTime.now().subtract(Duration(days: i * 3)),
        ),
      );
    }

    return obj;
  }

  // Eventually have history, labels and due dates
  static FixedPaymentObject _buildFixedPaymentObject (String title, double amount) {
    return FixedPaymentObject(title: title, paymentAmount: amount);
  }

  static double _doubleInRange(num start, num end) =>
      Random().nextDouble() * (end - start) + start;
}
