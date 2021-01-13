import 'package:flutter/material.dart';

/// Return a [Color]
/// Return a [Route]

mixin TilePresenter {
  /// For hints or messages to be displayed above [FinanceTile]
  String affirmation;
  Color affirmationColor;

  Color getTileColor();

  /// Lets FinanceTile know where to direct
  /// material page
  Widget getLandingPage();
}
