import 'dart:async';

import 'package:flutter/material.dart';
import 'package:github/widgets/avatar.dart';
import 'package:github/core/events.dart';
import 'package:github/widgets/loading_overlay.dart';
import 'package:github/core/store.dart';
import 'package:github/styles.dart';

class RepoList extends StatefulWidget {
  @override
  State<RepoList> createState() => _RepoListState();
}

class _RepoListState extends State<RepoList> {
  late StreamSubscription<dynamic> storeSubscription;
  List<Map<String, dynamic>> results = [];
  var isLoading = true;

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
        if (isLoading) LoadingOverlay(),
        if (results.isEmpty && !isLoading)
          const Center(
              child: Text(
            "No repo found!",
            style: titleTextStyle,
          ))
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
    final entryMap = widget.entryMap;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: spacing_2, vertical: spacing_1),
      child: GestureDetector(
        onTap: () {
          setState(() {
            isExpanded = !isExpanded;
          });
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(spacing_1),
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
          width: spacing_1,
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (entryMap["name"] != null)
                Text(
                  entryMap["name"],
                  style: titleTextStyle,
                ),
              if (entryMap["full_name"] != null)
                Text(
                  entryMap["full_name"],
                  style: subtitleTextStyle,
                  overflow: TextOverflow.fade,
                ),
              if (entryMap["language"] != null)
                Text(
                  entryMap["language"],
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
          height: spacing_1,
          width: double.infinity,
        ),
        if (entryMap["description"] != null)
          Text(
            entryMap["description"],
            style: descriptionTextStyle,
          ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            _Issues(entryMap),
            _Pulls(entryMap),
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

class _Pulls extends StatelessWidget {
  final Map<String, dynamic> entryMap;

  _Pulls(this.entryMap);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Store.main.getPulls(entryMap["pulls_url"]);
        Store.main.navigator.currentState?.pushNamed(
          "pulls",
          arguments: {"name": entryMap["name"]},
        );
      },
      child: const Text("See PRs!"),
    );
  }
}
