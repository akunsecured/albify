import 'package:albify/animations/slide_directions.dart';
import 'package:flutter/material.dart';

class CustomPageRouteBuilder extends PageRouteBuilder {
  final Widget? parent;
  final Widget child;
  final SlideDirections direction;
  final bool? isOpaque;
  
  CustomPageRouteBuilder({
    this.parent,
    required this.child,
    required this.direction,
    this.isOpaque
  }) : super(
    pageBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation
    ) => child,
    opaque: isOpaque ?? false,
    transitionsBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
      var from, to;

      switch (direction) {
        case SlideDirections.FROM_UP:
          from = Offset(0, -1);
          to = Offset(0, 1);
          break;
        case SlideDirections.FROM_RIGHT:
          from = Offset(1, 0);
          to = Offset(-1, 0);
          break;
        case SlideDirections.FROM_DOWN:
          from = Offset(0, 1);
          to = Offset(0, -1);
          break;
        case SlideDirections.FROM_LEFT:
          from = Offset(-1, 0);
          to = Offset(1, 0);
          break;
      }
      
      var childPosition =
        Tween<Offset>(begin: from, end: Offset.zero)
          .animate(animation);

      if (parent == null)
        return SlideTransition(
          position: childPosition,
          child: child
        );

      var parentPosition =
        Tween<Offset>(begin: Offset.zero, end: to)
          .animate(animation);

      return Stack(
        children: [
          SlideTransition(
            position: parentPosition,
            child: parent
          ),
          SlideTransition(
            position: childPosition,
            child: child
          )
        ],
      );
    },
  );

}