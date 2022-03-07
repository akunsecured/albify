import 'package:flutter/material.dart';

const int WEB_SIZE_WIDTH = 720;

double getPreferredSize(Size size) {
  return size.width > WEB_SIZE_WIDTH ? size.width / 3 : size.width;
}

const double RADIUS = 24;
const double SENDER_RADIUS = 4;