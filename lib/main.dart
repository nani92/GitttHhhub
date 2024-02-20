import 'package:flutter/material.dart';
import 'package:github/widgets/bottom_search_bar.dart';
import 'package:github/screens/issues.dart';
import 'package:github/screens/pulls.dart';
import 'package:github/screens/repo_list.dart';
import 'package:github/core/store.dart';
import 'package:github/screens/welcome.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Github searcher',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Github Searcher'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    Store.main.navigator = _navigatorKey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Navigator(key: _navigatorKey, onGenerateRoute: generateRoute,),
      bottomNavigationBar: BottomSearchBar(),
    );
  }

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case 'issues':
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (context) => Issues(repoName: args['name']));
      case 'pulls':
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (context) => Pulls(repoName: args['name']));
      case 'repos':
        return MaterialPageRoute(builder: (context) => RepoList());
      default:
        return MaterialPageRoute(builder: (context) => Welcome());
    }
  }
}
