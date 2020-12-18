import 'package:flutter/material.dart';

abstract class FinanceObject {
  String affirmation;
  String title, label_1, label_2;

  FinanceObject({
    @required this.title,
    this.label_1,
    this.label_2,
  });
}
