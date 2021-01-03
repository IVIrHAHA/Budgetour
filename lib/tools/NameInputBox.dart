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
  double _containerWidth;
  TextEditingController _textinputController = TextEditingController();

  /// child to be displayed in animated container
  /// ***either [showInputPrompt] or [showDisplay] 
  Widget _child;
  bool _displayMode;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      color: Colors.indigo,
      duration: Duration(milliseconds: 200),
      width: _containerWidth ?? widget.defaultWidth,
      child: _child ?? showDisplay(context),
      onEnd: () {
        _swap();
      },
    );
  }

  _collapseDisplay(bool collapse) {
    setState(() {
      if (collapse) {
        _containerWidth = 0;
      } else
        _containerWidth = widget.defaultWidth;
    });
  }

  /// METHOD: SWAP CHILD
  /// ----------------------------------------
  /// Swaps [_child] to be either [showDisplay] or [showInputPrompt]
  /// Then expand animatedBox
  /// ----------------------------------------
  _swap() {
    _child = _displayMode ? showDisplay(context) : showInputPrompt(context);
    _collapseDisplay(false);
  }

  /// METHOD: SHOW INPUT PROMPT
  /// ----------------------------------------
  /// Get user input data
  /// ----------------------------------------
  Widget showInputPrompt(BuildContext context) {
    String defaultText;
    if (widget.title is Text) {
      defaultText = (widget.title as Text).data;
    }

    return Container(
      color: Colors.black,
      child: TextFormField(
        onFieldSubmitted: (value) {
          /// Collapse AnimatedContainer and swap
          /// [_child] to call [showDisplay]
          _collapseDisplay(true);
          _displayMode = true;
        },
        controller: _textinputController,
        keyboardType: TextInputType.name,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: defaultText ?? 'Enter Text',
          labelStyle: TextStyle(
            color: Colors.white,
          ),
          hintStyle: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  /// METHOD: SHOW_DISPLAY
  /// --------------------------------------
  /// Builds the display mode of this widget
  /// --------------------------------------
  Widget showDisplay(BuildContext context) {
    return Material(
      color: Colors.black,
      child: InkWell(
        onTap: () {
          /// Collapse AnimatedContainer and swap
          /// [_child] to call [showInputPrompt]
          _collapseDisplay(true);
          _displayMode = false;
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
            overflow: TextOverflow.fade,
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
