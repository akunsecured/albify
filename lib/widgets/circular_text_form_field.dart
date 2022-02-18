import 'package:albify/common/utils.dart';
import 'package:flutter/material.dart';

class CircularTextFormField extends StatefulWidget {
  String hintText;
  Icon icon;
  Function(String? value)? validateFun;
  Function(String? value) onChangedFun;
  TextInputType? inputType;
  bool? obsecureText;
  bool? isConfirm;
  String? matchWith;

  CircularTextFormField(
    this.hintText,
    this.icon,
    this.validateFun,
    this.onChangedFun,
    {
      this.inputType,
      this.obsecureText,
      this.isConfirm,
      this.matchWith
    }
  );

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
          borderRadius: BorderRadius.circular(24)
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
      validator: (value) =>
        (widget.isConfirm ?? false) ? Utils.validateConfirmPassword(value, widget.matchWith) : widget.validateFun!(value),
      onChanged: (value) => widget.onChangedFun(value),
    );
  }
}