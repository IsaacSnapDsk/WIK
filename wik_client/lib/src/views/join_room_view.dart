import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wik_client/src/models/room.dart';
import 'package:wik_client/src/services/room_view_model.dart';
import 'package:wik_client/src/services/sockets_service.dart';
import 'package:wik_client/src/views/room_view.dart';
import 'package:wik_client/src/views/wik_appbar.dart';
import 'package:wik_client/src/widgets/wik_button.dart';

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class JoinRoomView extends ConsumerStatefulWidget {
  const JoinRoomView({super.key});

  @override
  ConsumerState<JoinRoomView> createState() => _JoinRoomViewState();
}

class _JoinRoomViewState extends ConsumerState<JoinRoomView> {
  /// The id we want to use for joining our room
  String? _joinId;

  /// The nickname for our player
  String? _nickname;

  /// Determines if we can submit the form or not
  bool _canSubmit = false;

  /// Determines if we have joined our room or not
  /// This is important as [_room] only becomes reactive
  /// to changes in our view model when this is true
  bool _roomJoined = false;

  /// Our current room
  Room? _room;

  Widget _buildInitialState() {
    return Scaffold(
      appBar: const WikAppBar(text: 'JOIN ROOM...'),
      body: Center(
        child: Container(
          width: 300,
          height: 300,
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text("Enter room details below:"),
              TextField(
                decoration: const InputDecoration(hintText: "Enter room id"),
                inputFormatters: [
                  UpperCaseTextFormatter(),
                ],
                onChanged: _onRoomIdChanged,
              ),
              TextField(
                decoration:
                    const InputDecoration(hintText: "Enter your nickname"),
                onChanged: _onNicknameChanged,
              ),
              const SizedBox(
                height: 25,
              ),
              WikButton(
                onPressed: () => _canSubmit ? _proceed() : null,
                text: 'Join Room',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _calcCanSubmit() {
    setState(() {
      //  If ANY of our values are null, this is false
      final canSubmit = _nickname != null && _joinId != null;

      //  Set our value to whether we are falsey or not
      _canSubmit = canSubmit;
    });
  }

  /// Initializes our listeners for room creation
  void _initListeners(RoomViewModel vm) {
    //  Subscribe to our player creation
    vm.subscribeToPlayerCreatedSuccess(context);

    //  Subscribe to our room being joined
    vm.subscribeToJoinRoomSuccess(context);

    //  Subscribe to room updates
    vm.subscribeToRoomUpdateSuccess(context);
  }

  /// Initializes our socket client and room view model
  RoomViewModel _initSocketClient() {
    //  Set our identifier to our username
    ref.read(socketIdentifier.notifier).state = _nickname;

    //  Get our view model
    final vm = ref.watch(roomViewModel);

    //  Set our initialized value to true
    ref.read(viewModelInitialized.notifier).state = true;

    //  Return our view model instance
    return vm;
  }

  /// Joins our room and toggles our flag so we can start
  /// listening to changes to our room
  void _joinRoom(RoomViewModel vm) {
    //  Create our room
    vm.joinRoom(_joinId!, _nickname!);

    //  Now start listening for our room
    setState(() => _roomJoined = true);
  }

  void _onNicknameChanged(String val) {
    //  Update our nickname value
    _nickname = val;

    //  Check if we can submit or not
    _calcCanSubmit();
  }

  void _onRoomIdChanged(String val) {
    //  Update our room name value
    _joinId = val;

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
    _joinRoom(vm);
  }

  @override
  Widget build(BuildContext context) {
    //  Check if we have a room or not
    if (_roomJoined) {
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
