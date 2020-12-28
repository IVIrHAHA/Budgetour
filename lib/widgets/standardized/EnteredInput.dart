import 'package:budgetour/tools/GlobalValues.dart';
import 'package:common_tools/ColorGenerator.dart';
import 'package:flutter/material.dart';

class EnteredInput extends StatelessWidget {
  final text;

  EnteredInput(this.text);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            text ?? '\$ 0.00',
            style: Theme.of(context).textTheme.headline5.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.normal
                ),
          ),
          Divider(
            color: ColorGenerator.fromHex(GColors.borderColor),
            thickness: 2,
          ),
        ],
      ),
    );
  }
}
