import 'package:flutter/material.dart';

const int WEB_SIZE_WIDTH = 720;

double getPreferredSize(Size size) {
  return isWebWidth(size) ? size.width / 3 : size.width;
}

bool isWebWidth(Size size) {
  return size.width > WEB_SIZE_WIDTH;
}

const double RADIUS = 24;
const double SENDER_RADIUS = 4;
const double MARGIN_HORIZONTAL = 16;
const double DIALOG_MARGIN = 30;