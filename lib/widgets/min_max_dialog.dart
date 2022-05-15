import 'package:albify/common/constants.dart';
import 'package:albify/common/utils.dart';
import 'package:albify/models/property_search_models.dart';
import 'package:albify/widgets/my_title_text.dart';
import 'package:albify/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MinMaxDialog extends StatefulWidget {
  final String title;
  final int multiple;
  final String? suffix;
  final RegExp? regExp;
  final Between values;

  const MinMaxDialog(
      {Key? key,
      required this.title,
      required this.values,
      this.multiple = 1,
      this.suffix,
      this.regExp})
      : super(key: key);

  @override
  State<MinMaxDialog> createState() => _MinMaxDialogState();
}

class _MinMaxDialogState extends State<MinMaxDialog> {
  num? from, to;

  @override
  void initState() {
    from = widget.values.from;
    to = widget.values.to;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.grey[200],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(RADIUS))),
        child: Container(
          width: getPreferredSize(MediaQuery.of(context).size),
          child: Container(
            margin: EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MyTitleText(title: widget.title),
                Utils.addVerticalSpace(24),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: from == null ? null : from.toString(),
                        keyboardType: TextInputType.number,
                        inputFormatters: widget.regExp == null
                            ? null
                            : <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    widget.regExp!)
                              ],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          suffixIcon: widget.suffix == null
                              ? null
                              : ConstrainedBox(
                                  constraints: BoxConstraints(
                                      maxWidth: 30, maxHeight: 30),
                                  child: Align(
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: EdgeInsets.all(2.0),
                                        child: Text(widget.suffix!,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      )),
                                ),
                        ),
                        onChanged: (value) => setState(() {
                          if (value.trim().isEmpty) {
                            from = null;
                          } else {
                            double num = double.parse(value);
                            from = (num * widget.multiple).toInt();
                          }
                        }),
                      ),
                    ),
                    Utils.addHorizontalSpace(MARGIN_HORIZONTAL),
                    MyTitleText(title: '-', withContainer: false),
                    Utils.addHorizontalSpace(MARGIN_HORIZONTAL),
                    Expanded(
                      child: TextFormField(
                        initialValue: to == null ? null : to.toString(),
                        keyboardType: TextInputType.number,
                        inputFormatters: widget.regExp == null
                            ? null
                            : <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    widget.regExp!)
                              ],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          suffixIcon: widget.suffix == null
                              ? null
                              : ConstrainedBox(
                                  constraints: BoxConstraints(
                                      maxWidth: 30, maxHeight: 30),
                                  child: Align(
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: EdgeInsets.all(2.0),
                                        child: Text(widget.suffix!,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      )),
                                ),
                        ),
                        onChanged: (value) => setState(() {
                          if (value.trim().isEmpty) {
                            to = null;
                          } else {
                            double num = double.parse(value);
                            to = (num * widget.multiple).toInt();
                          }
                        }),
                      ),
                    ),
                  ],
                ),
                Utils.addVerticalSpace(24),
                RoundedButton(
                    onPressed: () {
                      Navigator.pop(context, {'from': from, 'to': to});
                    },
                    text: 'Ok')
              ],
            ),
          ),
        ));
  }
}
