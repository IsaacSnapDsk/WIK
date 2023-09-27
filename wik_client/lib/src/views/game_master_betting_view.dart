import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:wik_client/src/models/bet.dart';
import 'package:wik_client/src/models/player.dart';
import 'package:wik_client/src/models/round.dart';
import 'package:wik_client/src/views/wik_appbar.dart';
import 'package:wik_client/src/widgets/wik_button.dart';

class GameMasterBettingView extends StatelessWidget {
  const GameMasterBettingView({
    required this.round,
    required this.players,
    required this.onStopBetting,
    super.key,
  });

  final List<Player> players;
  final Round round;

  final void Function() onStopBetting;

  List<Widget> _buildPlayerVoted(Player player) {
    //  Grab our bets
    final bets = round.bets;

    //  Check if our player has voted
    final voted =
        bets.firstWhereOrNull((Bet x) => x.playerId == player.id) != null;

    //  Our icon depends on if this player voted or not
    final icon = voted ? Icons.check : Icons.close;

    //  Our color depends on if the player voted or not
    final color = voted ? Colors.blueAccent : Colors.pink;

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

  bool _canSubmit() {
    //  Check if all our players have voted by seeing if everyone voted
    final allVoted = round.bets.length == players.length;

    return allVoted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WikAppBar(text: 'BETTING...'),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                "Players are currently betting...",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: WikButton(
                  onPressed: _canSubmit() ? onStopBetting : null,
                  text: 'Stop Betting?',
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (final player in players)
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            player.name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          ..._buildPlayerVoted(player),
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
