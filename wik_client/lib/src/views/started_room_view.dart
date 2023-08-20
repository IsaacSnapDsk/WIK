import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wik_client/src/models/room.dart';
import 'package:wik_client/src/services/room_view_model.dart';
import 'package:wik_client/src/views/betting_view.dart';

class StartedRoomView extends ConsumerStatefulWidget {
  const StartedRoomView({super.key});

  @override
  ConsumerState<StartedRoomView> createState() => _StartedRoomViewState();
}

class _StartedRoomViewState extends ConsumerState<StartedRoomView> {
  late Room _room;

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

  Widget _buildPlaceholder() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text("Some shit broke"),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: const Text("SOMETHING BROKE"),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //  Grab our room
    _room = ref.watch(roomViewModel).room!;

    //  Grab our current round
    final currentRound = _room.rounds[_room.currentRound];

    //  Return a view based on what phase we are in
    switch (currentRound.turn) {
      case 'Betting':
        return const BettingView();
      default:
        return _buildPlaceholder();
    }
  }
}
