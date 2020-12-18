import 'package:flutter/material.dart';

class EnhancedListTile extends StatelessWidget {
  final Widget leading, center, trailing;

  EnhancedListTile({this.leading, this.center, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: leading,
            flex: 1,
          ),
          Expanded(
            child: center,
            flex: 3,
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              child: trailing,
            ),
            flex: 1,
          ),
        ],
      ),
    );
  }
}
