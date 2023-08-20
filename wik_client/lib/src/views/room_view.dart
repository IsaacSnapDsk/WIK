import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wik_client/src/models/room.dart';
import 'package:wik_client/src/services/room_view_model.dart';
import 'package:wik_client/src/views/started_room_view.dart';

class RoomView extends ConsumerStatefulWidget {
  const RoomView({super.key});

  @override
  ConsumerState<RoomView> createState() => _RoomViewState();
}

class _RoomViewState extends ConsumerState<RoomView> {
  late Room _room;

  /// Our view model
  late RoomViewModel vm;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      //  Get our view model
      vm = ref.watch(roomViewModel);

      //  Subscribe to game start events
      vm.subscribeToStartGameSuccess(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    //  Listen to our room for changes
    _room = ref.watch(roomViewModel).room!;

    //  Check if we our game started
    final started = _room.started;

    //  If we started, return our started room view
    if (started) return const StartedRoomView();

    //  Else return our waiting room
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text("Waiting Room"),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            Text("You are in room: ${_room.name}"),
            const Text("Current Players: "),
            for (final player in _room.players) Text(player.name),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Start Game"),
            ),
          ]),
        ),
      ),
    );
  }
}
