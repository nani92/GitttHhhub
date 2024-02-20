import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:github/core/data.dart';
import 'package:github/core/events.dart';
import 'package:github/core/store.dart';
import 'package:github/screens/repo_list.dart';
import 'package:github/widgets/loading_overlay.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() {
  testWidgets('Repo list test', (WidgetTester tester) async {
    await mockNetworkImagesFor(
      () => tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: RepoList()),
        ),
      ),
    );

    //Test Loading Visible
    expect(find.byType(LoadingOverlay), findsOneWidget);
    final listRepo = [repoNoIssues, repoWithIssues];

    Store.main.send(RepositoriesFound(listRepo));
    await mockNetworkImagesFor(() => tester.pump());

    //Test elements visible and loading not
    expect(find.byType(LoadingOverlay), findsNothing);
    expect(find.byType(GestureDetector), findsExactly(listRepo.length));
    expect(find.text(listRepo.first.name), findsOneWidget);
    expect(find.text(listRepo.last.name), findsOneWidget);

    //Test showing details
    expect(find.text(listRepo.first.description), findsNothing);
    await tester.tap(find.text(listRepo.first.name));
    await tester.pump();
    expect(find.text(listRepo.first.description), findsOneWidget);

    //Test showing buttons
    expect(find.byType(TextButton), findsOneWidget);
    await tester.tap(find.text(listRepo.last.name));
    await tester.pump();
    //3 buttons should be showed cause there are 2 repos in the list
    //and only one of them has issues
    expect(find.byType(TextButton), findsExactly(3));
  });
}

const repoWithIssues = RepoData(
  "Test",
  "FullTest",
  "https://avatars.githubusercontent.com/u/7022074?v=4",
  "C",
  "Test",
  true,
  "",
  "",
);
const repoNoIssues = RepoData(
  "Test2",
  "FullTest2",
  "https://avatars.githubusercontent.com/u/7022074?v=4",
  "C#",
  "Testing",
  false,
  "",
  "",
);
