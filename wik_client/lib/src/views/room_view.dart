import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wik_client/src/models/game_master.dart';
import 'package:wik_client/src/models/player.dart';
import 'package:wik_client/src/models/room.dart';
import 'package:wik_client/src/services/room_view_model.dart';
import 'package:wik_client/src/views/started_room_view.dart';
import 'package:wik_client/src/views/wik_appbar.dart';
import 'package:wik_client/src/widgets/wik_button.dart';

class RoomView extends ConsumerStatefulWidget {
  const RoomView({super.key});

  @override
  ConsumerState<RoomView> createState() => _RoomViewState();
}

class _RoomViewState extends ConsumerState<RoomView> {
  Player? _player;

  late Room _room;

  late GameMaster? _gm;

  /// Our view model
  late RoomViewModel vm;

  final List<String> _images = [
    'glasses.png',
    'fs.gif',
    'grinch.png',
    'guapo.png',
    'mash.gif',
    'sol.png',
    'vibe.gif',
    'yeowch.gif',
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      //  Get our view model
      vm = ref.watch(roomViewModel);

      //  Subscribe to game start events
      vm.subscribeToStartGameSuccess(context);

      //  Subscribe to turn change events
      vm.subscribeToChangeTurnSuccessListener(context);
    });
  }

  Color _textColor(Player player) {
    //  If there is a player, then base it off if this is them
    if (_player != null) {
      return player.id == _player!.id ? Colors.blue : Colors.black;
    }
    //  Else, this is the GM so base it off the connection status
    return player.connected ? Colors.black : Colors.pink;
  }

  String _randomImage() {
    final rng = Random();

    final idx = rng.nextInt(_images.length);

    final name = _images[idx];

    return 'lib/src/assets/images/$name';
  }

  @override
  Widget build(BuildContext context) {
    //  Listen to our player for changes
    _player = ref.watch(roomViewModel).player;

    //  Listen to our room for changes
    _room = ref.watch(roomViewModel).room!;

    //  Listen to our gm for changes
    _gm = ref.watch(roomViewModel).gameMaster;

    //  Check if we our game started
    final started = _room.started;

    //  If we started, return our started room view
    if (started) return const StartedRoomView();

    //  Else return our waiting room
    return Scaffold(
      appBar: const WikAppBar(text: 'WAITING FOR PLAYERS...'),
      body: Center(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
          ),
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Text("Here's the join ID:"),
              Text(
                _room.joinId,
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.headlineLarge!.fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text("You are in room: ${_room.name}"),
              const Text("Current Players: "),
              Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                child: SingleChildScrollView(
                  child: Wrap(
                    children: [
                      for (final player in _room.players)
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.95,
                          ),
                          margin: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _textColor(player),
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                _randomImage(),
                                width: 50,
                              ),
                              Flexible(
                                child: Text(
                                  '${player.name} ${player.connected ? "" : "(disconnected)"}',
                                  style: TextStyle(
                                    color: _textColor(player),
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .fontSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              if (_gm != null)
                WikButton(
                  onPressed: () => vm.startGame(_room.id, _gm!.id),
                  text: 'Start Game',
                ),
            ],
          ),
        ),
      ),
    );
  }
}
