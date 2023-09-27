import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wik_client/src/models/room.dart';
import 'package:wik_client/src/services/room_view_model.dart';
import 'package:wik_client/src/views/room_view.dart';
import 'package:wik_client/src/views/wik_appbar.dart';
import 'package:wik_client/src/widgets/wik_button.dart';

class CreateRoomView extends ConsumerStatefulWidget {
  const CreateRoomView({super.key});

  @override
  ConsumerState<CreateRoomView> createState() => _CreateRoomViewState();
}

class _CreateRoomViewState extends ConsumerState<CreateRoomView> {
  /// The id we want to use for joining our room
  String? _roomName;

  /// The max number of rounds we want
  int? _maxRounds;

  /// Determines if we can submit the form or not
  bool _canSubmit = false;

  /// Our view model
  late RoomViewModel vm;

  /// Our current room
  Room? _room;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //  Get our view model
      vm = ref.watch(roomViewModel);

      //  Listen to our game master creation
      vm.subscribeToGameMasterCreatedSuccess(context);
    });
  }

  /// Builds our page for when there is NOT a room
  Widget _buildInitialState() {
    return Scaffold(
      appBar: const WikAppBar(text: 'CREATE A ROOM...'),
      body: Center(
        child: Container(
          width: 300,
          height: 350,
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text("Enter room details below:"),
              TextField(
                decoration: const InputDecoration(hintText: "Enter room name"),
                onChanged: _onRoomNameChanged,
              ),
              TextField(
                decoration: const InputDecoration(hintText: "Enter max rounds"),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                onChanged: _onMaxRoundsChanged,
              ),
              const SizedBox(
                height: 25,
              ),
              WikButton(
                onPressed: () =>
                    _canSubmit ? vm.createRoom(_roomName!, _maxRounds!) : null,
                text: 'Create Room',
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Determines if our form can be submitted
  void _calcCanSubmit() {
    setState(() {
      //  If ANY of our values are null, this is false
      final canSubmit = _maxRounds != null && _roomName != null;

      //  Set our value to whether we are falsey or not
      _canSubmit = canSubmit;
    });
  }

  /// Updates our max rounds based on the user input
  void _onMaxRoundsChanged(String val) {
    //  Parse the value into an integer
    final num = val.isNotEmpty ? int.parse(val) : null;

    //  Update our value
    _maxRounds = num;

    //  Check if we can submit or not
    _calcCanSubmit();
  }

  /// Update's our room name
  void _onRoomNameChanged(String val) {
    //  Update our room name value
    _roomName = val;

    //  Check if we can submit or not
    _calcCanSubmit();
  }

  @override
  Widget build(BuildContext context) {
    //  Check if we have a room or not
    _room = ref.watch(roomViewModel).room;

    //  If we do not have a room, return our initial state
    if (_room == null) {
      return _buildInitialState();
    }
    //  Else, return our existing state
    else {
      return const RoomView();
    }
  }
}
