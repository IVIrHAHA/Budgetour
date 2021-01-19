import 'package:flutter/material.dart';

/// Return a [Color]
/// Return a [Route]

mixin TilePresenter {
  Color getTileColor();

  /// For hints or messages to be displayed above [FinanceTile]
  Text getAffirmation();

  /// Lets FinanceTile know where to direct
  /// material page
  Widget getLandingPage();
}
