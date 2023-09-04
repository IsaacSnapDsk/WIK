import 'package:flutter/material.dart';
import 'package:wik_client/src/models/player.dart';
import 'package:wik_client/src/models/round.dart';

class GameMasterResultsView extends StatelessWidget {
  const GameMasterResultsView({
    required this.round,
    required this.players,
    required this.onStopPunishing,
    super.key,
  });

  final List<Player> players;
  final Round round;
  final void Function() onStopPunishing;

  List<Widget> _buildPlayerPunished(Player player) {
    //  Find the player in the room corresponding to this winner
    Player? real;
    for (int i = 0; i < players.length; i++) {
      if (players[i].id == player.id) {
        real = players[i];
        break;
      }
    }

    //  Check if our player has punished
    final punished = real!.punished;

    //  Our icon depends on if this player punished or not
    final icon = punished ? Icons.close : Icons.check;

    //  Our color depends on if the player punished or not
    final color = punished ? Colors.red : Colors.green;

    //  Our text depends on if the player punished or not
    final text = punished ? "Not Placed Punishment" : "Placed Punishment";

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
          "Punishing",
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
              const Text("Players are currently submitting punishments..."),
              const Text("Stop punishing?"),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: onStopPunishing,
                  child: const Text("Stop Punishing"),
                ),
              ),
              Row(
                children: [
                  for (final player in round.winners)
                    Column(
                      children: [
                        Text(player.name),
                        ..._buildPlayerPunished(player),
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
