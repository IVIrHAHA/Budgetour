import 'package:flutter/material.dart';

abstract class FinanceObject {
  String affirmation;
  String name, label_1, label_2;

  FinanceObject({
    @required this.name,
    this.label_1,
    this.label_2,
  });
}
