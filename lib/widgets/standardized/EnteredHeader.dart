import 'package:flutter/material.dart';

class EnteredHeader extends StatelessWidget {
  final String text;
  final Color color;

  EnteredHeader({this.text = '', this.color = Colors.black});

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
          ' Amount',
          style: theme.textTheme.headline6.copyWith(
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
