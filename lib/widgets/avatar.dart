import 'package:flutter/cupertino.dart';

class Avatar extends StatelessWidget {
  final String avatarPath;
  final double size;

  const Avatar({super.key, required this.avatarPath, this.size = 100});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ClipOval(
        child: Image.network(
          avatarPath,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}