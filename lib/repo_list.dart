import 'dart:async';

import 'package:flutter/material.dart';
import 'package:github/avatar.dart';
import 'package:github/events.dart';
import 'package:github/loading_overlay.dart';
import 'package:github/store.dart';
import 'package:github/styles.dart';

class RepoList extends StatefulWidget {
  @override
  State<RepoList> createState() => _RepoListState();
}

class _RepoListState extends State<RepoList> {
  late StreamSubscription<dynamic> storeSubscription;
  List<Map<String, dynamic>> results = [];
  var isLoading = false;

  @override
  void initState() {
    super.initState();
    storeSubscription = Store.main.listen((event) {
      switch (event.runtimeType) {
        case ClickedSearch:
          setState(() {
            isLoading = true;
          });
          break;
        case RepositoriesFound:
          setState(() {
            results = (event as RepositoriesFound).list;
            isLoading = false;
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
            for (var result in results) _ListElement(entryMap: result),
          ],
        ),
        if (isLoading) LoadingOverlay()
      ],
    );
  }
}

class _ListElement extends StatefulWidget {
  final Map<String, dynamic> entryMap;

  const _ListElement({super.key, required this.entryMap});

  @override
  State<_ListElement> createState() => _ElementState();
}

class _ElementState extends State<_ListElement> {
  var isExpanded = false;

  @override
  Widget build(BuildContext context) {
    print("Element: ${widget.entryMap}");
    final entryMap = widget.entryMap;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: () {
          setState(() {
            isExpanded = !isExpanded;
          });
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                _ElementTopView(entryMap: entryMap),
                AnimatedSwitcher(
                  duration: const Duration(seconds: 1),
                  child: isExpanded
                      ? _ElementDetails(entryMap: entryMap)
                      : const SizedBox(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ElementTopView extends StatelessWidget {
  final Map<String, dynamic> entryMap;

  const _ElementTopView({super.key, required this.entryMap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Avatar(avatarPath: entryMap["owner"]["avatar_url"]),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entryMap["name"].toString(),
                style: titleTextStyle,
              ),
              Text(
                entryMap["full_name"].toString(),
                style: subtitleTextStyle,
                overflow: TextOverflow.fade,
              ),
              Text(
                entryMap["language"].toString(),
                style: languageTextStyle,
              )
            ],
          ),
        ),
      ],
    );
  }
}

class _ElementDetails extends StatelessWidget {
  final Map<String, dynamic> entryMap;

  const _ElementDetails({super.key, required this.entryMap});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 8,
          width: double.infinity,
        ),
        Text(
          entryMap["description"],
          style: descriptionTextStyle,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            _Issues(entryMap),
          ],
        ),
      ],
    );
  }
}

class _Issues extends StatelessWidget {
  final Map<String, dynamic> entryMap;

  _Issues(this.entryMap);

  @override
  Widget build(BuildContext context) {
    return entryMap["open_issues"] > 0
        ? TextButton(
            onPressed: () {
              Store.main.getIssues(entryMap["issues_url"]);
              Store.main.navigator.currentState?.pushNamed(
                "issues",
                arguments: {"name": entryMap["name"]},
              );
            },
            child: const Text("See issues!"),
          )
        : const SizedBox();
  }
}
