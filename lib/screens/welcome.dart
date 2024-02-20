import 'package:flutter/cupertino.dart';
import 'package:github/styles.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SizedBox.expand(
      child: Center(
          child: Text(
        'Type in below to find repository!',
        style: titleTextStyle,
      )),
    );
  }
}
