import 'package:flutter/material.dart';

/// Return a [Color]
/// Return a [Route]

mixin TilePresenter {

  Color getTileColor();

  /// Lets FinanceTile know where to direct
  /// material page
  Widget getLandingPage();
}