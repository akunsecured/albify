import 'package:flutter/material.dart';

class MyCircleAvatar extends StatelessWidget {
  final String? avatarUrl;
  final double? maxRadius, radius;

  const MyCircleAvatar(
      {Key? key, this.maxRadius, this.radius, required this.avatarUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(avatarUrl);
    return CircleAvatar(
      backgroundColor:
          (avatarUrl == null || avatarUrl!.isEmpty) ? Colors.black : null,
      backgroundImage: (avatarUrl == null || avatarUrl!.isEmpty)
          ? null
          : NetworkImage(avatarUrl!),
      child: (avatarUrl == null || avatarUrl!.isEmpty)
          ? Text('?', style: TextStyle(color: Colors.white, fontSize: 32))
          : null,
      radius: radius,
      maxRadius: maxRadius,
    );
  }
}
