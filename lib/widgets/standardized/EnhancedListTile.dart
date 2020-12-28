import 'package:flutter/material.dart';

class EnhancedListTile extends StatelessWidget {
  final Widget leading, center, trailing;
  final Color backgroundColor;
  final EdgeInsets padding;

  EnhancedListTile({
    this.leading,
    this.center,
    this.trailing,
    this.backgroundColor = Colors.transparent,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      color: backgroundColor,
      child: Row(
        children: [
          Expanded(
            child: leading ?? Container(),
            flex: 3,
          ),
          Expanded(
            child: center ?? Container(),
            flex: 6,
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              child: trailing,
            ),
            flex: 3,
          ),
        ],
      ),
    );
  }
}
