import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github/repo_details.dart';

class RepoList extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  RepoList(GlobalKey<NavigatorState> this.navigatorKey);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < 5; i++)
          GestureDetector(
              onTap: () {
                navigatorKey.currentState?.pushNamed("details");
              },
              child: SizedBox(height: 60, child: Text("Repo $i")))
      ],
    );
  }
}
