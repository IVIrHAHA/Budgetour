import 'package:flutter/material.dart';

class EnteredHeader extends StatelessWidget {
  final String text;
  final String text2;
  final Color color;

  EnteredHeader({this.text = '', this.color = Colors.black, this.text2});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Row(
      children: [
        Text(
          text,
          style: theme.textTheme.headline6.copyWith(
            color: color,
          ),
        ),
        Text(
          text2 ?? ' Amount',
          style: theme.textTheme.headline6.copyWith(
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
