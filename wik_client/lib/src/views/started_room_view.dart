import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wik_client/src/models/room.dart';
import 'package:wik_client/src/services/room_view_model.dart';

class StartedRoomView extends ConsumerStatefulWidget {
  const StartedRoomView({super.key});

  @override
  ConsumerState<StartedRoomView> createState() => _StartedRoomViewState();
}

class _StartedRoomViewState extends ConsumerState<StartedRoomView> {
  // late Room _room;

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text("Started Room"),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: const Text("TODO"),
        ),
      ),
    );
  }
}
