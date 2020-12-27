import 'package:budgetour/models/BudgetObject.dart';
import 'package:budgetour/tools/GlobalValues.dart';
import 'package:common_tools/ColorGenerator.dart';
import 'package:flutter/material.dart';

import 'EnhancedListTile.dart';

class InfoTile extends StatelessWidget {
  final String title;
  final String infoText;

  const InfoTile({
    Key key,
    this.infoText,
    this.title,
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
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      trailing: Row(
        children: [
          Text(
            infoText,
            style: TextStyle(
                color: ColorGenerator.fromHex(GColors.negativeNumber),
                fontWeight: FontWeight.bold),
          ),
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