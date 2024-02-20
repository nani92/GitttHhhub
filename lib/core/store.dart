import 'package:flutter/widgets.dart';
import 'package:github/core/api.dart';
import 'package:github/core/data.dart';
import 'package:github/core/events.dart';
import 'package:super_store/super_store.dart';

class Store {
  static final main = MainSection();
  static final manager = SuperStoreManager([main]);
}

class MainSection extends SuperStoreSection {
  @override
  String get sectionName => 'main';
  late GlobalKey<NavigatorState> navigator;

  void search(String phrase) {
    Store.main.send(ClickedSearch());

    Api.search(phrase).then((value) {
      final list = value[_KEY_ITEMS] as List<dynamic>;
      final mapList = list.map((e) => RepoData.fromJson(e)).toList();
      Store.main.send(RepositoriesFound(mapList));
    }).catchError((e) {
      //TODO handle error
      print(e.toString());
      Store.main.send(RepositoriesFound([]));
    });
  }

  void getIssues(String link) {
    Api.getList(link.split('{/number}').first).then((value) {
      final mapList = (value).map((e) => e as Map<String, dynamic>).toList();
      Store.main.send(IssuesReceived(mapList));
    }).catchError((e) {
      //TODO handle error
      print(e.toString());
      Store.main.send(IssuesReceived([]));
    });
  }

  void getPulls(String link) {
    Api.getList(link.split('{/number}').first).then((value) {
      final mapList = (value).map((e) => e as Map<String, dynamic>).toList();
      Store.main.send(PullsReceived(mapList));
    }).catchError((e) {
      //TODO handle error
      print(e.toString());
      Store.main.send(PullsReceived([]));
    });
  }
}

const _KEY_ITEMS = 'items';
