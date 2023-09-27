import 'package:flutter/material.dart';
import 'package:wik_client/src/views/wik_appbar.dart';
import 'package:wik_client/src/widgets/wik_button.dart';

class GameMasterWaitingView extends StatelessWidget {
  const GameMasterWaitingView({
    required this.onStopWaiting,
    super.key,
  });

  final void Function(bool) onStopWaiting;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WikAppBar(text: 'WAITING...'),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Did the clip kill?",
                style: TextStyle(
                  fontSize: 36,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  WikButton(
                    onPressed: () => onStopWaiting(true),
                    text: 'Yes',
                    color: Colors.blueAccent,
                  ),
                  const SizedBox(width: 30),
                  WikButton(
                    onPressed: () => onStopWaiting(false),
                    text: 'No',
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
