import 'dart:math';

import 'package:budgetour/objects/BudgetObject.dart';
import 'package:budgetour/objects/FinanceObject.dart';
import 'package:budgetour/objects/Transaction.dart';

class InitTestData {
  static final List<FinanceObject> dummyFOList = List<FinanceObject>();

  static initTileList() {
    dummyFOList.add(_buildBudgetObj('Food', 150, 10));
    dummyFOList.add(_buildBudgetObj('Gas', 135, 4));
    dummyFOList.add(_buildBudgetObj('Weed', 30, 2));

    return dummyFOList;
  }

  static BudgetObject _buildBudgetObj(
      String title, double allocationAmount, int transactionQTY,) {

    BudgetObject obj =
        BudgetObject(title: title, allocatedAmount: allocationAmount);

    // Log random transactions
    for (int i = 0; i < transactionQTY; i++) {
      obj.logTransaction(
        Transaction.fillDate(
          description: 'Tran_$i',
          amount: _doubleInRange(Random(), 5, 50),
        ),
      );
    }

    return obj;
  }

  static double _doubleInRange(Random source, num start, num end) =>
      source.nextDouble() * (end - start) + start;
}
