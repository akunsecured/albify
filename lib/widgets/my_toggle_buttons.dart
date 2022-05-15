import 'package:albify/common/constants.dart';
import 'package:albify/themes/app_style.dart';
import 'package:albify/widgets/my_title_text.dart';
import 'package:flutter/material.dart';

class MyToggleButtons extends StatefulWidget {
  final String title;
  final int optionNum;
  final Map<String, dynamic> options;
  final bool? firstAny;
  final Function(dynamic) onPressed;
  final int? selected;

  const MyToggleButtons(
      {Key? key,
      required this.title,
      required this.optionNum,
      required this.options,
      required this.onPressed,
      this.selected,
      this.firstAny = true})
      : super(key: key);

  @override
  State<MyToggleButtons> createState() => _MyToggleButtonsState();
}

class _MyToggleButtonsState extends State<MyToggleButtons> {
  late List<bool> isSelected;

  @override
  void initState() {
    if (widget.selected != null) {
      isSelected = List.filled(
          widget.firstAny! ? widget.optionNum + 1 : widget.optionNum, false);
      isSelected[widget.selected!] = true;
    } else {
      isSelected = [
        true,
        ...List.filled(
            widget.firstAny! ? widget.optionNum : widget.optionNum - 1, false)
      ];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          MyTitleText(title: widget.title),
          ToggleButtons(
            fillColor: AppStyle.appColorBlack,
            color: AppStyle.appColorBlack,
            selectedColor: Colors.white,
            isSelected: isSelected,
            children: getOptions(),
            onPressed: (int newIndex) {
              setState(() {
                for (int index = 0; index < isSelected.length; index++) {
                  if (index == newIndex) {
                    isSelected[index] = true;
                  } else {
                    isSelected[index] = false;
                  }
                }
              });
              if (widget.firstAny!) {
                if (newIndex == 0) {
                  widget.onPressed(null);
                } else {
                  widget
                      .onPressed(widget.options.values.toList()[newIndex - 1]);
                }
              } else {
                widget.onPressed(widget.options.values.toList()[newIndex]);
              }
            },
          ),
        ],
      );

  Widget buildOption(String text) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: MARGIN_HORIZONTAL),
      child: Text(text));

  List<Widget> getOptions() => widget.firstAny!
      ? [
          buildOption('Any'),
          ...(widget.options.keys.map((option) => buildOption(option)).toList())
        ]
      : widget.options.keys.map((option) => buildOption(option)).toList();
}
