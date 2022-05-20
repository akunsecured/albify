import 'package:albify/common/constants.dart';
import 'package:albify/widgets/circular_text_form_field.dart';
import 'package:flutter/material.dart';

class MyPasswordRequireDialog extends StatelessWidget {
  const MyPasswordRequireDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController textEditingController = TextEditingController();
    return AlertDialog(
      title: Text('Please enter your password'),
      content: Form(
        key: _formKey,
        child: CircularTextFormField(
          hintText: 'Password',
          validateFun: validatePasswordField,
          textEditingController: textEditingController,
          obsecureText: true,
        ),
      ),
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(RADIUS)),
      elevation: 0,
      actions: [
        TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Navigator.of(context).pop(textEditingController.text);
              }
            },
            child: Text('Ok')),
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel')),
      ],
    );
  }

  validatePasswordField(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field must be filled';
    }
    return null;
  }
}
