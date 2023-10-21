import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wik_client/src/models/game_master.dart';
import 'package:wik_client/src/models/player.dart';
import 'package:wik_client/src/models/room.dart';
import 'package:wik_client/src/models/round.dart';
import 'package:wik_client/src/models/score.dart';
import 'package:wik_client/src/services/room_view_model.dart';
import 'package:wik_client/src/views/wik_appbar.dart';

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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Do better next time :/",
          style: TextStyle(
            fontSize: Theme.of(context).textTheme.headlineLarge!.fontSize,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Drinks: ",
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.headlineLarge!.fontSize,
                fontWeight: FontWeight.bold,
                color: _currentPunishment!.drinks > 0
                    ? Colors.blueAccent
                    : Colors.black,
              ),
            ),
            Text(
              _currentPunishment!.drinks.toString(),
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.headlineLarge!.fontSize,
                fontWeight: FontWeight.bold,
                color: _currentPunishment!.drinks > 0
                    ? Colors.blueAccent
                    : Colors.black,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Shots: ",
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.headlineLarge!.fontSize,
                fontWeight: FontWeight.bold,
                color: _currentPunishment!.shots > 0
                    ? Colors.blueAccent
                    : Colors.black,
              ),
            ),
            Text(
              _currentPunishment!.shots.toString(),
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.headlineLarge!.fontSize,
                fontWeight: FontWeight.bold,
                color: _currentPunishment!.shots > 0
                    ? Colors.blueAccent
                    : Colors.black,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "BB: ",
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.headlineLarge!.fontSize,
                fontWeight: FontWeight.bold,
                color: _currentPunishment!.bb > 0
                    ? Colors.blueAccent
                    : Colors.black,
              ),
            ),
            Text(
              _currentPunishment!.bb.toString(),
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.headlineLarge!.fontSize,
                fontWeight: FontWeight.bold,
                color: _currentPunishment!.bb > 0
                    ? Colors.blueAccent
                    : Colors.black,
              ),
            ),
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
      appBar: WikAppBar(),
      body: Center(
        child: Container(
          decoration: _needPunishment()
              ? const BoxDecoration(
                  image: DecorationImage(
                    opacity: 0.3,
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        'https://www.mensjournal.com/.image/ar_1:1%2Cc_fill%2Ccs_srgb%2Cfl_progressive%2Cq_auto:good%2Cw_1200/MjAxMDU0Nzk0OTI2NzkzODIx/kevin-james-on-the-king-of-queens.jpg'),
                  ),
                )
              : null,
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Your Punishment for Round ${_room.currentRound + 1}",
                style: TextStyle(
                  color: Colors.pink,
                  fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
                ),
              ),
              if (_needPunishment())
                _buildPunishments()
              else
                Text(
                  "None! You got off easy this time fuckass",
                  style: TextStyle(
                    fontSize:
                        Theme.of(context).textTheme.displaySmall!.fontSize,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
