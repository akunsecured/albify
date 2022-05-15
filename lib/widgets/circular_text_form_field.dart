import 'package:albify/common/constants.dart';
import 'package:flutter/material.dart';

class CircularTextFormField extends StatefulWidget {
  final String hintText;
  final Icon? icon;
  final Function? validateFun;
  final TextEditingController textEditingController;
  final TextInputType? inputType;
  final bool? obsecureText;
  final bool? isConfirm;
  final String? matchWith;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final int? maxLines;
  final int? maxLength;
  final Color? fillColor;

  CircularTextFormField({
    required this.hintText,
    required this.validateFun,
    required this.textEditingController,
    this.icon,
    this.inputType,
    this.obsecureText,
    this.isConfirm,
    this.matchWith,
    this.textInputAction = TextInputAction.next,
    this.focusNode,
    this.nextFocusNode,
    this.maxLines = 1,
    this.maxLength,
    this.fillColor
  });

  set matchWith(String? value) => matchWith = value;

  @override
  _CircularTextFormFieldState createState() => _CircularTextFormFieldState();
}

class _CircularTextFormFieldState extends State<CircularTextFormField> {
  late bool _passwordVisible;

  @override
  void initState() {
    _passwordVisible = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.inputType ?? TextInputType.text,
      obscureText: (widget.obsecureText ?? false) ? !_passwordVisible : false,
      decoration: InputDecoration(
        filled: widget.fillColor != null,
        fillColor: widget.fillColor,
        prefixIcon: widget.icon,
        hintText: widget.hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(RADIUS)
        ),
        suffixIcon: (widget.obsecureText ?? false) ?
          IconButton(
            onPressed: () {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
            icon: Icon(
              _passwordVisible ?
              Icons.visibility :
              Icons.visibility_off
            )
          ) :
          null
      ),
      validator: (value) {
        if (widget.validateFun != null) {
          return widget.validateFun!(value);
        }
        return null;
      },
      controller: widget.textEditingController,
      textInputAction: widget.textInputAction,
      focusNode: widget.focusNode,
      onFieldSubmitted: (value) {
        if (widget.focusNode != null && widget.nextFocusNode != null) {
          widget.focusNode!.unfocus();
          FocusScope.of(context).requestFocus(widget.nextFocusNode);
        }
      },
      minLines: 1,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
    );
  }
}