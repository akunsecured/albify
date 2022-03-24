import 'package:albify/common/constants.dart';
import 'package:flutter/material.dart';

class CircularTextFormField extends StatefulWidget {
  final String hintText;
  final Icon icon;
  final Function validateFun;
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

  CircularTextFormField({
    required this.hintText,
    required this.icon,
    required this.validateFun,
    required this.textEditingController,
    this.inputType,
    this.obsecureText,
    this.isConfirm,
    this.matchWith,
    this.textInputAction = TextInputAction.next,
    this.focusNode,
    this.nextFocusNode,
    this.maxLines = 1,
    this.maxLength
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
      validator: (value) => widget.validateFun(value),
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