import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox.expand(
          child: ColoredBox(
            color: Colors.grey.withAlpha(100),
          ),
        ),
        const CircularProgressIndicator(),
      ],
    );
  }

}
