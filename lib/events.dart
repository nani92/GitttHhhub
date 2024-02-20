import 'package:super_store/super_store.dart';

class RepositoriesFound extends Event {
  final List<Map<String, dynamic>> list;

  RepositoriesFound(this.list);

  @override
  get eventName => 'repositoties_found ${list.length}';
}

class ClickedSearch extends Event {
  @override
  get eventName => 'clicked_search';
}

class IssuesReceived extends Event {
  final List<Map<String, dynamic>> list;

  IssuesReceived(this.list);

  @override
  get eventName => 'issues_received ${list.length}';
}