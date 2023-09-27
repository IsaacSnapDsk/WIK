import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wik_client/src/models/bet.dart';

class WaitingView extends ConsumerStatefulWidget {
  const WaitingView({required this.currentBet, super.key});

  /// The current bet
  final Bet currentBet;

  @override
  ConsumerState<WaitingView> createState() => _WaitingViewState();
}

class _WaitingViewState extends ConsumerState<WaitingView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              "Your current bet:",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
                fontWeight: FontWeight.bold,
                fontSize: Theme.of(context).textTheme.headlineSmall!.fontSize,
              ),
            ),
            Text(
              widget.currentBet.kill ? "Kill" : "No Kill",
              style: TextStyle(
                color: widget.currentBet.kill ? Colors.blue : Colors.pink,
                fontWeight: FontWeight.bold,
                fontSize: Theme.of(context).textTheme.headlineSmall!.fontSize,
              ),
            ),
            Text(
              "${widget.currentBet.amount} ${widget.currentBet.type}",
              style: TextStyle(
                color: widget.currentBet.kill ? Colors.blue : Colors.pink,
                fontSize: Theme.of(context).textTheme.headlineSmall!.fontSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
