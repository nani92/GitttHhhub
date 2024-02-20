import 'dart:async';

import 'package:flutter/material.dart';
import 'package:github/widgets/avatar.dart';
import 'package:github/core/events.dart';
import 'package:github/widgets/loading_overlay.dart';
import 'package:github/core/store.dart';
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
              padding: const EdgeInsets.symmetric(horizontal: spacing_2, vertical: spacing_1),
              child: Text(
                'PRs for ${widget.repoName}:',
                style: titleTextStyle,
              ),
            ),
            for (var issue in results)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: spacing_2, vertical: spacing_1),
                child: Card(
                    child: Padding(
                  padding: const EdgeInsets.all(spacing_1),
                  child: Row(
                    children: [
                      Avatar(
                        avatarPath: issue['user']['avatar_url'],
                        size: 50,
                      ),
                      const SizedBox(
                        width: spacing_2,
                      ),
                      Expanded(
                          child: Text(
                        issue['title'],
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
              'Sorry, no PRs to display',
              style: subtitleTextStyle,
            ),
          ),
        if (isLoading) const LoadingOverlay()
      ],
    );
  }
}
