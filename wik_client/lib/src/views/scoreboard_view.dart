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
      appBar: const WikAppBar(),
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
                WikButton(
                  onPressed: () => vm.nextRound(_room.id, _gm!.id),
                  text: "Next Round",
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
                              const Text("Wins: "),
                              Text(player.wins.toString()),
                            ],
                          ),
                          Row(
                            children: [
                              const Text("Drinks: "),
                              Text(player.drinks.toString()),
                            ],
                          ),
                          Row(
                            children: [
                              const Text("Shots: "),
                              Text(player.shots.toString()),
                            ],
                          ),
                          Row(
                            children: [
                              const Text("BB: "),
                              Text(player.bb.toString()),
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
