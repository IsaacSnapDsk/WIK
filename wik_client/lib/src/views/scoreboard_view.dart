import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wik_client/src/models/game_master.dart';
import 'package:wik_client/src/models/player.dart';
import 'package:wik_client/src/models/room.dart';
import 'package:wik_client/src/models/round.dart';
import 'package:wik_client/src/models/score.dart';
import 'package:wik_client/src/services/room_view_model.dart';

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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text("Waiting Room ID: ${_room.id}"),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text("Total Scores for round ${_room.currentRound + 1}"),
              if (_gm != null)
                ElevatedButton(
                  onPressed: () => vm.nextRound(_room.id, _gm!.id),
                  child: const Text("Next Round"),
                ),
              for (final player in _room.players)
                Column(
                  children: [
                    Text(player.name),
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
            ],
          ),
        ),
      ),
    );
  }
}
