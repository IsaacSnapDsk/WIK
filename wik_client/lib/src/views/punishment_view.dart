import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wik_client/src/models/game_master.dart';
import 'package:wik_client/src/models/player.dart';
import 'package:wik_client/src/models/room.dart';
import 'package:wik_client/src/models/round.dart';
import 'package:wik_client/src/models/score.dart';
import 'package:wik_client/src/services/room_view_model.dart';

class PunishmentView extends ConsumerStatefulWidget {
  const PunishmentView({super.key});

  @override
  ConsumerState<PunishmentView> createState() => _PunishmentViewState();
}

class _PunishmentViewState extends ConsumerState<PunishmentView> {
  late Room _room;

  late Round _round;

  late GameMaster? _gm;

  /// Our view model
  late RoomViewModel vm;

  late Score? _currentPunishment;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      //  Get our view model
      vm = ref.watch(roomViewModel);
    });
  }

  Widget _buildPunishments() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Try better next time :/"),
        Row(
          children: [
            const Text("Drinks: "),
            Text(_currentPunishment!.drinks.toString()),
          ],
        ),
        Row(
          children: [
            const Text("Shots: "),
            Text(_currentPunishment!.shots.toString()),
          ],
        ),
        Row(
          children: [
            const Text("BB: "),
            Text(_currentPunishment!.bb.toString()),
          ],
        ),
      ],
    );
  }

  bool _needPunishment() {
    //  If our punishment is null, return false
    if (_currentPunishment == null) return false;

    //  Else, if all of our values are 0, return false
    if (_currentPunishment!.bb == 0 &&
        _currentPunishment!.drinks == 0 &&
        _currentPunishment!.shots == 0) {
      return false;
    }

    //  Else, it's true
    return true;
  }

  @override
  Widget build(BuildContext context) {
    //  Listen to our room for changes
    _room = ref.watch(roomViewModel).room!;

    //  Grab our current round
    _round = _room.rounds[_room.currentRound];

    //  Listen to our gm for changes
    _gm = ref.watch(roomViewModel).gameMaster;

    //  Listen to our punishment for changes
    _currentPunishment = ref.watch(roomViewModel).currentPunishment;

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
              Text("Your Punishment for round: ${_room.currentRound + 1}"),
              if (_needPunishment())
                _buildPunishments()
              else
                Text("None! You got off easy this time fuckass"),
            ],
          ),
        ),
      ),
    );
  }
}
