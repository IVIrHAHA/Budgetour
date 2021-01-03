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

  NameInputBox(
      {this.title,
      this.hint,
      this.controller,
      this.borderColor,
      this.backgroundColor,
      this.defaultWidth});

  @override
  _NameInputBoxState createState() => _NameInputBoxState(this.defaultWidth);
}

class _NameInputBoxState extends State<NameInputBox> {
  final List<Widget> children = <Widget>[];
  double containerWidth;

  _NameInputBoxState(double defaultWidth) {
    this.containerWidth = defaultWidth;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      color: Colors.indigo,
      duration: Duration(milliseconds: 200),
      width: containerWidth,
      child: buildDisplayMode(context),
      onEnd: () {
        _collapse(false);
      },
    );
  }

  _collapse(bool collapse) {
    setState(() {
      if (collapse) {
        containerWidth = 0;
      } else
        _setDefaultWidth();
    });
  }

  /// Get a default width size for [containerWidth]
  /// so there is a value to return to when container
  /// expands
  _setDefaultWidth() {
    if (widget.defaultWidth != null) {
      containerWidth = widget.defaultWidth;
    } else
      LayoutBuilder(builder: (_, size) {
        containerWidth = size.maxWidth;
        return null;
      });
  }

  /// Builds the display mode of this widget
  Widget buildDisplayMode(BuildContext context) {
    return Material(
      color: Colors.black,
      child: InkWell(
        onTap: () {
          _collapse(true);
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

// Card(
//           color: headerColor,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 12.0),
//             child: InkWell(
//               onTap: () => showAlertDialog(context),
//               child: Text(
//                 budgetName ?? 'Enter Name',
//                 style: Theme.of(context).textTheme.headline5,
//               ),
//             ),
//           ),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(GlobalValues.roundedEdges),
//             side: BorderSide(
//                 color: ColorGenerator.fromHex(GColors.borderColor), width: 1),
//           ),
//         ),
