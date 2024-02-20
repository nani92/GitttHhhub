import 'package:flutter/material.dart';
import 'package:github/core/store.dart';
import 'package:github/styles.dart';

class BottomSearchBar extends StatefulWidget {
  const BottomSearchBar({super.key});

  @override
  State<BottomSearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<BottomSearchBar> {
  late TextEditingController textController;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SizedBox(
        height: SEARCH_BAR_HEIGHT,
        width: double.infinity,
        child: ColoredBox(
          color: Colors.lightBlue.shade50,
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: textController,
                  ),
                ),
              ),
              SizedBox(
                width: 64,
                child: IconButton(
                  onPressed: () {
                    Store.main.search(textController.text);
                    Store.main.navigator.currentState?.pushReplacementNamed('repos');
                  },
                  icon: const Icon(
                    Icons.search,
                    color: Colors.blue,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
