import 'package:flutter/material.dart';

class EnhancedListTile extends StatelessWidget {
  final Widget leading, center, trailing;

  EnhancedListTile({this.leading, this.center, this.trailing});

  // nothing really just trying something, can delete whenever
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: leading,
            flex: 3,
          ),
          Expanded(
            child: center,
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
