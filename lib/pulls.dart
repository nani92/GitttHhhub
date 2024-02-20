import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github/avatar.dart';
import 'package:github/events.dart';
import 'package:github/loading_overlay.dart';
import 'package:github/store.dart';
import 'package:github/styles.dart';

class Pulls extends StatefulWidget {
  final String repoName;

  const Pulls({super.key, required this.repoName});

  @override
  State<Pulls> createState() => _PullsState();
}

class _PullsState extends State<Pulls> {
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
  void dispose() {
    storeSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "PRs for ${widget.repoName}:",
                style: titleTextStyle,
              ),
            ),
            for (var issue in results)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                      Expanded(
                          child: Text(
                        issue["title"],
                        style: subtitleTextStyle,
                      )),
                    ],
                  ),
                )),
              )
          ],
        ),
        if (results.isEmpty && !isLoading)
          Center(
            child: Text(
              "Sorry no PRs to display",
              style: subtitleTextStyle,
            ),
          ),
        if (isLoading) LoadingOverlay()
      ],
    );
  }
}
