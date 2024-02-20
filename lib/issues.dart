import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github/avatar.dart';
import 'package:github/events.dart';
import 'package:github/loading_overlay.dart';
import 'package:github/store.dart';
import 'package:github/styles.dart';

class Issues extends StatefulWidget {
  final String repoName;

  const Issues({super.key, required this.repoName});

  @override
  State<Issues> createState() => _IssuesState();
}

class _IssuesState extends State<Issues> {
  late StreamSubscription<dynamic> storeSubscription;
  List<Map<String, dynamic>> results = [];
  var isLoading = true;

  @override
  void initState() {
    super.initState();
    storeSubscription = Store.main.listen((event) {
      switch (event.runtimeType) {
        case IssuesReceived:
          setState(() {
            isLoading = false;
            results = (event as IssuesReceived).list;
          });
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print("ISSSUES $results");
    return Stack(
      children: [
        ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text("Issues for ${widget.repoName}:", style: titleTextStyle,),
            ),
            for (var issue in results)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Card(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Avatar(
                        avatarPath: issue["user"]["avatar_url"],
                        size: 50,
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(child: Text(issue["title"], style: subtitleTextStyle,)),
                    ],
                  ),
                )),
              )
          ],
        ),
        if(isLoading)
          LoadingOverlay()
      ],
    );
  }
}
