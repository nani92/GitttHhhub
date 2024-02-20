import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:github/api.dart';
import 'package:github/events.dart';
import 'package:super_store/super_store.dart';

class Store {
  static final main = MainSection();
  static final manager = SuperStoreManager([main]);
}

class MainSection extends SuperStoreSection {
  @override
  String get sectionName => "main";
  late GlobalKey<NavigatorState> navigator;

  void search(String phrase) {
    Store.main.send(ClickedSearch());

    Api.search(phrase).then((value) {
      final list = value[_KEY_ITEMS] as List<dynamic>;
      final mapList = list.map((e) => e as Map<String, dynamic>).toList();
      Store.main.send(RepositoriesFound(mapList));
    });
  }

  void getIssues(String link) {
    Api.getList(link.split("{/number}").first).then((value) {
      final mapList = (value)
          .map((e) => e as Map<String, dynamic>)
          .toList();
      Store.main.send(IssuesReceived(mapList));
    });
  }

  void getPulls(String link) {
    Api.getList(link.split("{/number}").first).then((value) {
      final mapList = (value)
          .map((e) => e as Map<String, dynamic>)
          .toList();
      Store.main.send(IssuesReceived(mapList));
    });
  }
}

const _KEY_ITEMS = "items";
