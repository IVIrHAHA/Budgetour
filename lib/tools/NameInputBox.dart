import 'package:common_tools/ColorGenerator.dart';
import 'package:flutter/material.dart';

import 'GlobalValues.dart';

class NameInputBox extends StatefulWidget {
  final Text title;
  final Widget hint;
  final String errorMessage;
  final TextEditingController controller;
  final Color backgroundColor;
  final Color borderColor;
  final double defaultWidth;
  final Function(String) onSubmitted;
  final bool Function(String) isValidFunction;

  NameInputBox({
    this.title,
    @required this.defaultWidth,
    this.hint,
    this.errorMessage = 'not valid',
    this.controller,
    this.borderColor,
    this.backgroundColor,
    this.onSubmitted,
    this.isValidFunction,
  });

  @override
  _NameInputBoxState createState() => _NameInputBoxState();
}

class _NameInputBoxState extends State<NameInputBox> {
  double _containerWidth;
  Text _errorText;
  Color _errorColor;

  /// child to be displayed in animated container
  /// ***either [showInputPrompt] or [showDisplay]
  Widget _child;
  bool _displayMode = true;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      color: widget.backgroundColor,
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

  _initErrorMsg() {
    // Display error message
    _errorText = Text(widget.errorMessage.toLowerCase());
    _errorColor = Colors.red;
    _showDisplay();
  }

  _showDisplay() {
    /// Collapse AnimatedContainer and swap
    /// [_child] to call [showDisplay]
    _collapseDisplay(true);
    _displayMode = true;
  }

  _showInput() {
    /// Collapse AnimatedContainer and swap
    /// [_child] to call [showInputPrompt]
    _collapseDisplay(true);
    _displayMode = false;
  }

  /// METHOD: SWAP CHILD
  /// ----------------------------------------
  /// Swaps [_child] to be either [showDisplay] or [showInputPrompt]
  /// Then expand animatedBox
  /// Called only by the AnimatedBox in [build] method
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
    if (widget.title != null) {
      defaultText = widget.title.data;
    }

    return Container(
      child: TextFormField(
        autofocus: true,
        onFieldSubmitted: (value) {
          /// If [widget.isValidFunction] is not null let
          /// [this] perform error message
          if (widget.isValidFunction != null) {
            if (widget.isValidFunction(value)) {
              _errorColor = null;
              _errorText = null;
              widget.onSubmitted(value);
            }
            // Show error message
            else {
              _initErrorMsg();
            }
          }

          /// Pass data back without opinion
          else
            widget.onSubmitted(value);

          _showDisplay();
        },
        controller: widget.controller,
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
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          _showInput();
        },
        child: Container(
          decoration: BoxDecoration(
            color: _errorColor ?? Colors.transparent,
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
            child: _errorText ?? widget.title,
            textAlign: TextAlign.center,
            overflow: TextOverflow.fade,
            softWrap: false,
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
