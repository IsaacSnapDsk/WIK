import 'package:flutter/material.dart';
import 'package:wik_client/src/models/player.dart';
import 'package:wik_client/src/models/round.dart';
import 'package:wik_client/src/views/wik_appbar.dart';
import 'package:wik_client/src/widgets/wik_button.dart';

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
    final color = punished ? Colors.pink : Colors.blueAccent;

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

  Widget _buildLosers(BuildContext context) {
    return Column(
      children: [
        Text(
          "Damn...no one won???",
          style: TextStyle(
            fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WikAppBar(text: 'PUNISHING...'),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: round.winners.isEmpty
              ? const BoxDecoration(
                  image: DecorationImage(
                    repeat: ImageRepeat.repeat,
                    opacity: 0.2,
                    image: NetworkImage(
                        'https://i.kym-cdn.com/entries/icons/original/000/038/646/E_HXiZqX0Ac2UyZ.jpg'),
                  ),
                )
              : null,
          child: Column(
            children: [
              Text(
                "Players are currently submitting punishments...",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if (round.winners.isEmpty) _buildLosers(context),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: WikButton(
                  onPressed: onStopPunishing,
                  text: 'Stop Punishing',
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (final player in round.winners)
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            player.name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          ..._buildPlayerPunished(player),
                        ],
                      ),
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
