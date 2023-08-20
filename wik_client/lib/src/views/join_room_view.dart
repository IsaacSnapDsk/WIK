import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wik_client/src/services/room_view_model.dart';

class JoinRoomView extends ConsumerStatefulWidget {
  const JoinRoomView({super.key});

  @override
  ConsumerState<JoinRoomView> createState() => _JoinRoomViewState();
}

class _JoinRoomViewState extends ConsumerState<JoinRoomView> {
  /// The id we want to use for joining our room
  String? _roomId;

  /// The nickname for our player
  String? _nickname;

  /// Determines if we can submit the form or not
  bool _canSubmit = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //  Get our view model
      final vm = ref.watch(roomViewModel);

      vm.subscribeToTestSuccess(context);
      vm.subscribeToJoinRoomSuccess(context);
    });
  }

  void _calcCanSubmit() {
    setState(() {
      //  If ANY of our values are null, this is false
      final canSubmit = _nickname != null && _roomId != null;

      //  Set our value to whether we are falsey or not
      _canSubmit = canSubmit;
    });
  }

  void _onNicknameChanged(String val) {
    //  Update our nickname value
    _nickname = val;

    //  Check if we can submit or not
    _calcCanSubmit();
  }

  void _onRoomIdChanged(String val) {
    //  Update our room name value
    _roomId = val;

    //  Check if we can submit or not
    _calcCanSubmit();
  }

  @override
  Widget build(BuildContext context) {
    //  Load our view model
    final vm = ref.watch(roomViewModel);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text("Join Room"),
      ),
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
              ElevatedButton(
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                    Colors.blue,
                  ),
                  foregroundColor: MaterialStatePropertyAll(
                    Colors.white,
                  ),
                ),
                child: const Text("Join Room"),
                onPressed: () =>
                    _canSubmit ? vm.joinRoom(_roomId!, _nickname!) : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}