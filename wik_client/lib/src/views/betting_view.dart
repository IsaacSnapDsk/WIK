import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wik_client/src/services/room_view_model.dart';

const List<String> wagers = <String>['Dranks', 'BeeBee', 'SHOTS'];

class BettingView extends ConsumerStatefulWidget {
  const BettingView({super.key});

  @override
  ConsumerState<BettingView> createState() => _BettingViewState();
}

class _BettingViewState extends ConsumerState<BettingView> {
  /// The players choice for the kill/bet
  bool? _kill;

  /// The type of bet - drinks, bb, shots
  String _wager = wagers.first;

  /// Determines if we can submit the form or not
  int? _amount;

  /// Determines if we can submit the form or not
  bool _canSubmit = false;

  // @override
  // void initState() {
  //   super.initState();

  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //     //  Get our view model
  //     final vm = ref.watch(votingViewModel);

  //     vm.subscribeToTestSuccess(context);
  //     vm.subscribeToJoinRoomSuccess(context);
  //   });
  // }

  void _calcCanSubmit() {
    setState(() {
      //  If ANY of our values are null, this is false
      final canSubmit = _kill != null && _amount != null;

      //  Set our value to whether we are falsey or not
      _canSubmit = canSubmit;
    });
  }

  void _onWagerChanged(String? val) {
    //  Update our nickname value
    _wager = val!;

    //  Check if we can submit or not
    _calcCanSubmit();
  }

  void _onAmountChanged(String val) {
    //  Parse the value into an integer
    final num = val.isNotEmpty ? int.parse(val) : null;

    //  Update our nickname value
    _amount = num;

    //  Check if we can submit or not
    _calcCanSubmit();
  }

  Widget _buildBet() {
    if (_kill == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text("Will it KILL?"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                    Colors.red,
                  ),
                  foregroundColor: MaterialStatePropertyAll(
                    Colors.white,
                  ),
                ),
                child: const Text("YES"),
                onPressed: () {
                  setState(() {
                    _kill = true;
                    print('kill: $_kill');
                  });
                },
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
                child: const Text("NO"),
                onPressed: () {
                  setState(() {
                    _kill = false;
                    print('kill: $_kill');
                  });
                },
              ),
            ],
          ),
          Row(
            children: [
              ElevatedButton(
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                    Colors.black,
                  ),
                  foregroundColor: MaterialStatePropertyAll(
                    Colors.white,
                  ),
                ),
                child: const Text("ROCK"),
                onPressed: () {
                  setState(() {
                    _kill = true;
                    _wager = "SHOTS";
                    _amount = 2;
                    print('kill: $_kill, wager: $_wager, amount: $_amount');
                  });
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (_) {
                  //       return const WaitingView();
                  //     },
                  //   ),
                  // ),
                },
              ),
            ],
          )
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text("Place your Bets Here"),
          DropdownButton<String>(
            value: _wager,
            icon: const Icon(Icons.arrow_downward),
            elevation: 16,
            style: const TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: _onWagerChanged,
            items: wagers.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          TextField(
            decoration: const InputDecoration(hintText: "Enter your wager"),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            onChanged: _onAmountChanged,
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
            child: const Text("Submit Bet"),
            onPressed: () => _canSubmit
                ? print('kill: $_kill, wager: $_wager, amount: $_amount')
                : null,
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //  Load our view model
    // final vm = ref.watch(roomViewModel);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text("Betting"),
      ),
      body: Center(
        child: Container(
            width: 300,
            height: 300,
            padding: const EdgeInsets.all(8.0),
            child: _buildBet()),
      ),
    );
  }
}
