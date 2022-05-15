import 'package:albify/common/constants.dart';
import 'package:albify/widgets/my_title_text.dart';
import 'package:flutter/material.dart';

class MyDropdownMenu extends StatefulWidget {
  final Map<int, String> options;
  final Function? onChanged;
  final bool isExpanded;
  final String? title;
  final int? selected;

  MyDropdownMenu(
      {required this.options,
      this.onChanged,
      this.isExpanded = true,
      this.title,
      this.selected});

  @override
  State<MyDropdownMenu> createState() => _MyDropdownMenuState();
}

class _MyDropdownMenuState extends State<MyDropdownMenu> {
  late int? value;

  @override
  void initState() {
    value = widget.selected ?? -1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      child: Column(
        children: [
          widget.title != null
              ? MyTitleText(title: widget.title!)
              : Container(),
          Container(
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(RADIUS),
                border: Border.all(color: Colors.black, width: 2)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                isExpanded: widget.isExpanded,
                value: value,
                items: widget.options.keys
                    .map((option) => buildMenuItem(option))
                    .toList(),
                onChanged: (newValue) {
                  if (widget.onChanged != null) {
                    widget.onChanged!(newValue);
                  }
                  setState(() {
                    value = newValue;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  DropdownMenuItem<int> buildMenuItem(int option) => DropdownMenuItem(
      value: option, child: Text(widget.options[option].toString()));
}
