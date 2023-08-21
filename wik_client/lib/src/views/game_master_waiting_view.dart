import 'package:flutter/material.dart';

class GameMasterWaitingView extends StatelessWidget {
  const GameMasterWaitingView({
    required this.onStopWaiting,
    super.key,
  });

  final void Function(bool) onStopWaiting;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text(
          "Waiting",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Text(
                "Did the clip kill?",
                style: TextStyle(
                  fontSize: 36,
                ),
              ),
              Row(
                children: [
                  ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.red),
                      foregroundColor: MaterialStatePropertyAll(Colors.black),
                    ),
                    onPressed: () => onStopWaiting(false),
                    child: const Text("No"),
                  ),
                  ElevatedButton(
                    onPressed: () => onStopWaiting(true),
                    child: const Text("Yes"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
