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
        child: Column(children: [
          const Text("Your current bet:"),
          Text(widget.currentBet.kill ? "Kill" : "No Kill"),
          Text("${widget.currentBet.amount} ${widget.currentBet.type}"),
        ]),
      ),
    );
  }
}
