import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({super.key});

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