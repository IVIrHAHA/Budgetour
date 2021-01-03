import 'package:common_tools/ColorGenerator.dart';
import 'package:flutter/material.dart';

import 'GlobalValues.dart';

class NameInputBox extends StatefulWidget {
  final Widget title;
  final Widget hint;
  final TextEditingController controller;
  final Color backgroundColor;
  final Color borderColor;
  final double defaultWidth;

  NameInputBox({
    this.title,
    this.hint,
    this.controller,
    this.borderColor,
    this.backgroundColor,
    @required this.defaultWidth,
  });

  @override
  _NameInputBoxState createState() => _NameInputBoxState();
}

class _NameInputBoxState extends State<NameInputBox> {
  final List<Widget> children = <Widget>[];
  double containerWidth;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      color: Colors.indigo,
      duration: Duration(milliseconds: 200),
      width: containerWidth ?? widget.defaultWidth,
      child: showDisplay(context),
      onEnd: () {
        _collapseDisplay(false);
      },
    );
  }

  _collapseDisplay(bool collapse) {
    setState(() {
      if (collapse) {
        containerWidth = 0;
      } else
        containerWidth = widget.defaultWidth;
    });
  }

  /// Builds the display mode of this widget
  Widget showDisplay(BuildContext context) {
    return Material(
      color: Colors.black,
      child: InkWell(
        onTap: () {
          _collapseDisplay(true);
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: ColorGenerator.fromHex(GColors.borderColor),
              width: 1,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(
              GlobalValues.roundedEdges,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: DefaultTextStyle(
            child: widget.title,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            style: Theme.of(context)
                .textTheme
                .headline5
                .copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
