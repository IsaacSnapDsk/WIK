import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wik_client/src/services/room_view_model.dart';

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

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //  Get our view model
      final vm = ref.watch(roomViewModel);

      vm.subscribeToTestSuccess(context);
      vm.subscribeToCreateRoomSuccess(context);
    });
  }

  void _calcCanSubmit() {
    setState(() {
      //  If ANY of our values are null, this is false
      final canSubmit = _maxRounds != null && _roomName != null;

      //  Set our value to whether we are falsey or not
      _canSubmit = canSubmit;
    });
  }

  //
  void _onMaxRoundsChanged(String val) {
    //  Parse the value into an integer
    final num = val.isNotEmpty ? int.parse(val) : null;

    //  Update our value
    _maxRounds = num;

    //  Check if we can submit or not
    _calcCanSubmit();
  }

  void _onRoomNameChanged(String val) {
    //  Update our room name value
    _roomName = val;

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
        title: const Text("Create a Room"),
      ),
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
              ElevatedButton(
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                    Colors.blue,
                  ),
                  foregroundColor: MaterialStatePropertyAll(
                    Colors.white,
                  ),
                ),
                child: const Text("Create Room"),
                onPressed: () =>
                    _canSubmit ? vm.createRoom(_roomName!, _maxRounds!) : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
