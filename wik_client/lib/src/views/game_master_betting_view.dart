import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:wik_client/src/models/bet.dart';
import 'package:wik_client/src/models/player.dart';
import 'package:wik_client/src/models/round.dart';

class GameMasterBettingView extends StatefulWidget {
  const GameMasterBettingView({
    required this.round,
    required this.players,
    required this.onStopBetting,
    super.key,
  });

  final List<Player> players;
  final Round round;

  final void Function() onStopBetting;

  @override
  State<GameMasterBettingView> createState() => _GameMasterBettingViewState();
}

class _GameMasterBettingViewState extends State<GameMasterBettingView> {
  List<Widget> _buildPlayerVoted(Player player) {
    //  Grab our bets
    final bets = widget.round.bets;

    //  Check if our player has voted
    final voted =
        bets.firstWhereOrNull((Bet x) => x.playerId == player.id) != null;

    //  Our icon depends on if this player voted or not
    final icon = voted ? Icons.check : Icons.close;

    //  Our color depends on if the player voted or not
    final color = voted ? Colors.green : Colors.red;

    //  Our text depends on if the player voted or not
    final text = voted ? "Placed Bet" : "Not Bet";

    //  Return our list of widgets
    return [
      Icon(
        icon,
        color: color,
      ),
      Text(
        text,
        style: TextStyle(
          color: color,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text(
          "Betting",
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
              const Text("Players are currently betting..."),
              const Text("Stop betting?"),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: widget.onStopBetting,
                  child: const Text("Stop Betting"),
                ),
              ),
              Row(
                children: [
                  for (final player in widget.players)
                    Column(
                      children: [
                        Text(player.name),
                        ..._buildPlayerVoted(player),
                      ],
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
