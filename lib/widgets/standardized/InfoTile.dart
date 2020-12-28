import 'package:budgetour/models/BudgetObject.dart';
import 'package:budgetour/tools/GlobalValues.dart';
import 'package:common_tools/ColorGenerator.dart';
import 'package:flutter/material.dart';

import 'EnhancedListTile.dart';

class InfoTile extends StatelessWidget {
  final String title;
  final String infoText;
  final Color titleColor;
  final Color infoTextColor;

  const InfoTile({
    Key key,
    this.title,
    this.titleColor = Colors.white,
    this.infoText,
    this.infoTextColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EnhancedListTile(
      backgroundColor: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      leading: Container(
        child: Text(
          title,
          style: TextStyle(
            color: titleColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      trailing: Row(
        children: [
          infoText != null ? Text(
            infoText,
            style: TextStyle(
                color: infoTextColor,
                fontWeight: FontWeight.bold),
          ) : Container(),

          Flexible(
            fit: FlexFit.tight,
            child: Container(),
          ),
          Icon(
            Icons.more_vert,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
