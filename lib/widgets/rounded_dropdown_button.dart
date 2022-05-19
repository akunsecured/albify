import 'package:albify/common/constants.dart';
import 'package:flutter/material.dart';

class RoundedDropdownButton extends StatelessWidget {
  final List<DropdownMenuItem<dynamic>> items;
  final void Function(dynamic) onChanged;
  final int value;

  RoundedDropdownButton(
      {required this.items, required this.onChanged, required this.value});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      items: this.items,
      onChanged: this.onChanged,
      value: this.value,
      decoration: InputDecoration(
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(RADIUS))),
    );
  }
}
