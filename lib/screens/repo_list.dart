import 'dart:async';

import 'package:flutter/material.dart';
import 'package:github/core/data.dart';
import 'package:github/widgets/avatar.dart';
import 'package:github/core/events.dart';
import 'package:github/widgets/loading_overlay.dart';
import 'package:github/core/store.dart';
import 'package:github/styles.dart';

class RepoList extends StatefulWidget {
  const RepoList({super.key});

  @override
  State<RepoList> createState() => _RepoListState();
}

class _RepoListState extends State<RepoList> {
  late StreamSubscription<dynamic> storeSubscription;
  List<RepoData> repos = [];
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
            repos = (event as RepositoriesFound).list;
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
            for (var repo in repos) _ListElement(data: repo),
          ],
        ),
        if (isLoading) const LoadingOverlay(),
        if (repos.isEmpty && !isLoading)
          const Center(
              child: Text(
            'No repo found!',
            style: titleTextStyle,
          ))
      ],
    );
  }
}

class _ListElement extends StatefulWidget {
  final RepoData data;

  const _ListElement({super.key, required this.data});

  @override
  State<_ListElement> createState() => _ElementState();
}

class _ElementState extends State<_ListElement> {
  var isExpanded = false;

  @override
  Widget build(BuildContext context) {

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
                _ElementTopView(data: widget.data),
                AnimatedSwitcher(
                  duration: const Duration(seconds: 1),
                  child: isExpanded
                      ? _ElementDetails(data: widget.data)
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
  final RepoData data;

  const _ElementTopView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Avatar(avatarPath: data.avatar),
        const SizedBox(
          width: spacing_1,
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Text(
                  data.name,
                  style: titleTextStyle,
                ),
                Text(
                  data.fullName,
                  style: subtitleTextStyle,
                  overflow: TextOverflow.fade,
                ),
                Text(
                  data.language,
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
  final RepoData data;

  const _ElementDetails({super.key, required this.data});

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
          Text(
            data.description,
            style: descriptionTextStyle,
          ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            _Issues(data),
            _Pulls(data),
          ],
        ),
      ],
    );
  }
}

class _Issues extends StatelessWidget {
  final RepoData data;

  _Issues(this.data);

  @override
  Widget build(BuildContext context) {
    return data.hasIssues
        ? TextButton(
            onPressed: () {
              Store.main.getIssues(data.issueLink);
              Store.main.navigator.currentState?.pushNamed(
                'issues',
                arguments: {'name': data.name},
              );
            },
            child: const Text('See issues!'),
          )
        : const SizedBox();
  }
}

class _Pulls extends StatelessWidget {
  final RepoData data;

  _Pulls(this.data);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Store.main.getPulls(data.pullsLink);
        Store.main.navigator.currentState?.pushNamed(
          'pulls',
          arguments: {'name': data.name},
        );
      },
      child: const Text('See PRs!'),
    );
  }
}
