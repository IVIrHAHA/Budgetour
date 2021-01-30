/*
 * Allows program to interface with all FinaceObjects
 */
import 'dart:convert';

import 'package:budgetour/models/finance_objects/FixedPaymentObject.dart';
import 'package:budgetour/models/interfaces/StatMixin.dart';
import 'package:budgetour/models/interfaces/TilePresentorMixin.dart';
import 'package:budgetour/tools/GlobalValues.dart';
import 'package:flutter/material.dart';
import '../../widgets/FinanceTile.dart';
import '../BudgetourReserve.dart';
import 'BudgetObject.dart';

/// with [TilePresenter] allows [FinanceTile] to interface with this behaviour
abstract class FinanceObject<E> with CashHolder, TilePresenter, StatMixin<E> {
  String name;

  double _objectID;

  /// What category this instance pertains to
  final int categoryID;

  FinanceObject({
    @required this.name,
    @required this.categoryID,
  }) {
    this._objectID = double.parse(('${this.name.hashCode}.${this.categoryID}'));
  }

  /// Gets json *representative of the financeObject. This way, all finance objects
  /// can be stored in a single table where only key values can be queried via sql.
  /// However, the entire (child) object will be stored as a json.
  toJson();

  Map<String, dynamic> toMap() {
    var map = {
      DbNames.fo_Category: categoryID,
      DbNames.fo_ObjectId: id,
      DbNames.fo_CashReserve: cashReserve,
      DbNames.fo_Object: jsonEncode(this),
      DbNames.fo_Type: this.runtimeType.toString(),
    };
    return map;
  }

  static FinanceObject fromMap(Map tableMap) {
    BudgetourReserve clerk = BudgetourReserve.clerk;
    FinanceObject loadedObject;

    var jsonMap = jsonDecode(tableMap[DbNames.fo_Object]);

    var classType = tableMap[DbNames.fo_Type];

    if (classType == (BudgetObject).toString()) {
      loadedObject = BudgetObject.fromJson(jsonMap);
    }
    else if(classType == (FixedPaymentObject).toString()) {
      /// TODO: Implement this
    }
    clerk.assign(loadedObject, tableMap[DbNames.fo_CashReserve]);
    return loadedObject;
  }

  double get id => this._objectID;
}
