import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wik_client/src/models/room.dart';
import 'package:wik_client/src/services/room_view_model.dart';
import 'package:wik_client/src/services/sockets_service.dart';
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

  /// Determines if we have created our room or not
  /// This is important as [_room] only becomes reactive
  /// to changes in our view model when this is true
  bool _roomCreated = false;

  /// Our current room
  Room? _room;

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
                onPressed: () => _canSubmit ? _proceed() : null,
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

  /// Creates our room and toggles our flag so we can start
  /// listening to changes to our room
  void _createRoom(RoomViewModel vm) {
    //  Create our room
    vm.createRoom(_roomName!, _maxRounds!);

    //  Now start listening for our room
    setState(() => _roomCreated = true);
  }

  /// Initializes our listeners for room creation
  void _initListeners(RoomViewModel vm) {
    //  Listen to our game master creation
    vm.subscribeToGameMasterCreatedSuccess(context);

    //  Listen to our room being created
    vm.subscribeToCreateRoomSuccess(context);

    //  Subscribe to our room being joined
    vm.subscribeToJoinRoomSuccess(context);
  }

  /// Initializes our socket client and room view model
  RoomViewModel _initSocketClient() {
    //  Set our identifier to our room name
    ref.read(socketIdentifier.notifier).state = _roomName;

    //  Get our view model
    final vm = ref.watch(roomViewModel);

    //  Set our initialized value to true
    ref.read(viewModelInitialized.notifier).state = true;

    //  Return our view model instance
    return vm;
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

  /// Initializes our SocketClient, establishes listeners,
  /// and creates our room
  void _proceed() {
    //  Init our socket client and view model
    final vm = _initSocketClient();

    //  Init our listeners
    _initListeners(vm);

    //  Create our room
    _createRoom(vm);
  }

  @override
  Widget build(BuildContext context) {
    //  Check if we have a room or not
    if (_roomCreated) {
      _room = ref.watch(roomViewModel).room;
    }

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
