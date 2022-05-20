import 'package:flutter/material.dart';

import 'my_text.dart';

class MyErrorPrinter extends StatelessWidget {
  final Object? error;

  const MyErrorPrinter({Key? key, this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(error.toString());
    return Align(
      alignment: Alignment.center,
      child: MyText(text: error.toString()),
    );
  }
}
