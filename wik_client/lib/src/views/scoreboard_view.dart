import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wik_client/src/models/game_master.dart';
import 'package:wik_client/src/models/player.dart';
import 'package:wik_client/src/models/room.dart';
import 'package:wik_client/src/models/round.dart';
import 'package:wik_client/src/services/room_view_model.dart';
import 'dart:math' as math;

import 'package:wik_client/src/views/wik_appbar.dart';
import 'package:wik_client/src/widgets/wik_button.dart';

class ScoreboardView extends ConsumerStatefulWidget {
  const ScoreboardView({super.key});

  @override
  ConsumerState<ScoreboardView> createState() => _ScoreboardViewState();
}

class _ScoreboardViewState extends ConsumerState<ScoreboardView> {
  late Room _room;

  late Round _round;

  late GameMaster? _gm;

  /// Our view model
  late RoomViewModel vm;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      //  Get our view model
      vm = ref.watch(roomViewModel);
    });
  }

  bool _playerIsWinner(Player player) {
    //  Grab our current round's winners
    final winners = _round.winners;

    //  Check if our player is in that array
    final playerWinner = winners.firstWhereOrNull((p) => p.id == player.id);

    //  If playerWinner is null, we did not win
    return playerWinner != null;
  }

  Color _textColor(int amt, String key, String playerId) {
    //  If we are in round 1 AND our amt is > 0, return pink
    if (_room.currentRound == 0) {
      if (amt > 0) {
        return Colors.pink;
      } else {
        return Colors.black;
      }
    }

    //  Get the previous round
    final prevRound = _room.rounds[_room.currentRound - 1];

    //  Grab the score from the previous round based player id
    final prevScores =
        prevRound.scores.where((x) => x.playerId == playerId).toList();

    //  Get the previous amount based on key
    int prevAmt = 0;

    for (int i = 0; i < prevScores.length; i++) {
      prevAmt += switch (key) {
        'drinks' => prevScores[i].drinks,
        'shots' => prevScores[i].shots,
        'bb' => prevScores[i].bb,
        _ => 0,
      };
    }

    //  Grab the amount based on key
    // final prevAmt = switch (key) {
    //   'drinks' => prevScore!.drinks,
    //   'shots' => prevScore!.shots,
    //   'bb' => prevScore!.bb,
    //   _ => 0,
    // };

    //  If our current is greater than the previous, make it pink
    if (amt > prevAmt) return Colors.pink;

    //  Else, just return black
    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    //  Listen to our room for changes
    _room = ref.watch(roomViewModel).room!;

    //  Grab our current round
    _round = _room.rounds[_room.currentRound];

    //  Listen to our gm for changes
    _gm = ref.watch(roomViewModel).gameMaster;

    //  Else return our waiting room
    return Scaffold(
      appBar: WikAppBar(),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                "Total Scores for Round ${_room.currentRound + 1}",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              if (_gm != null)
                Column(
                  children: [
                    WikButton(
                      onPressed: () => vm.nextRound(_room.id, _gm!.id),
                      text: "Next Round",
                    ),
                    SizedBox(height: 20),
                    if (_room.currentRound + 1 == (_room.maxRounds / 2).round())
                      WikButton(
                        onPressed: () => vm.startHalftime(_room.id, _gm!.id),
                        text: 'Start Halftime',
                      ),
                  ],
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (final player in _room.players)
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            player.name,
                            style: TextStyle(
                              color: _playerIsWinner(player)
                                  ? Colors.blueAccent
                                  : Colors.pink,
                              decoration: TextDecoration.underline,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .fontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              const Text(
                                "Wins: ",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                player.wins.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                "Drinks: ",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                player.drinks.toString(),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: _textColor(
                                      player.drinks, 'drinks', player.id),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                "Shots: ",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                player.shots.toString(),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: _textColor(
                                      player.shots, 'shots', player.id),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                "BB: ",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                player.bb.toString(),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: _textColor(player.bb, 'bb', player.id),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(width: 50),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
