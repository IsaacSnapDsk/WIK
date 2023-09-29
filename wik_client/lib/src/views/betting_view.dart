import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wik_client/src/services/room_view_model.dart';
import 'package:wik_client/src/models/room.dart';
import 'package:wik_client/src/models/player.dart';
import 'package:wik_client/src/models/bet.dart';
import 'package:wik_client/src/util/bet_limit_formatter.dart';
import 'package:wik_client/src/views/waiting_view.dart';
import 'package:wik_client/src/views/wik_appbar.dart';
import 'package:wik_client/src/widgets/wik_button.dart';

const List<String> wagers = <String>['Drink', 'Shot', 'BB'];

class BettingView extends ConsumerStatefulWidget {
  const BettingView({super.key});

  @override
  ConsumerState<BettingView> createState() => _BettingViewState();
}

class _BettingViewState extends ConsumerState<BettingView> {
  /// The text editing controller to handle our amount
  final TextEditingController _amountController = TextEditingController();

  /// The players choice for the kill/bet
  bool? _kill;

  /// The type of bet - drinks, bb, shots
  String _wager = wagers.first;

  /// Determines if we can submit the form or not
  int? _amount;

  /// Determines if we can submit the form or not
  bool _canSubmit = false;

  /// Determines if we have selected rock or not
  bool _rock = false;

  /// The max amount the player can bet for the wager
  int _maxAmt = 10;

  /// Our wagers players can pick from
  List<String> _filteredWagers = wagers;

  /// Local room instance
  late Room _room;

  /// Local player instance
  late Player _player;

  //Calculates if the player can submit their bet
  void _calcCanSubmit() {
    setState(() {
      //  If ANY of our values are null, this is false
      final canSubmit = _kill != null && _amount != null;

      //  Set our value to whether we are falsey or not
      _canSubmit = canSubmit;
    });
  }

  // Sets wager state and checks if player can submit
  void _onWagerChanged(String? val) {
    //  Update our nickname value
    _wager = val!;

    //  Our amout changes depending on what we changed the wager to
    _maxAmt = switch (val) {
      'Drink' => 10,
      'BB' => 1,
      'Shot' => _player.usedDoubleShot ? 1 : 2,
      _ => 1,
    };

    //  Reset our amount
    _amount = 0;

    //  Reset our form
    _amountController.clear();

    //  Check if we can submit or not
    _calcCanSubmit();
  }

  // Sets amount state and checks if player can submit
  void _onAmountChanged(String val) {
    //  Parse the value into an integer
    final num = val.isNotEmpty ? int.parse(val) : null;

    //  Update our nickname value
    _amount = num;

    //  Check if we can submit or not
    _calcCanSubmit();
  }

  // Submits the bet to the server
  void _onSubmitBet() {
    //  Create our bet
    final bet = _createBet();

    //  Get our view model
    final vm = ref.watch(roomViewModel);

    //  Submit our bet
    vm.submitBet(_room.id, bet);
  }

  /// Creates a bet from the current state in the form of the [Bet] model
  Bet _createBet() {
    return Bet(
      playerId: _player.id,
      kill: _kill!,
      type: _wager,
      amount: _amount!,
    );
  }

  Widget _buildBetting() {
    /// Get the current room and player from the view model
    /// to get the submited bet from the server
    _room = ref.watch(roomViewModel).room!;
    _player = ref.watch(roomViewModel).player!;

    /// Our filtered wagers will just be our wagers
    /// UNLESS the player has used all of their BBs
    _filteredWagers = _player.bbStock > 0 ? wagers : wagers.sublist(0, 2);

    /// Find the  player's current bet from the list of bets
    /// in the current round
    Bet? currentBet;
    final bets = _room.rounds[_room.currentRound].bets;
    for (final bet in bets) {
      if (bet.playerId == _player.id) {
        currentBet = bet;
        break;
      }
    }

    // If client has the current bet, show the waiting view
    if (currentBet != null) {
      return WaitingView(currentBet: currentBet);

      /// If the client does not have the current bet and the player has
      /// not chosen kill, show the betting view
    } else if (_kill == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "Will It KILL?",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              WikButton(
                  onPressed: () {
                    setState(() {
                      _kill = true;
                      print('kill: $_kill');
                    });
                  },
                  color: Colors.blueAccent,
                  text: 'YES'),
              WikButton(
                  onPressed: () {
                    setState(() {
                      _kill = false;
                      print('kill: $_kill');
                    });
                  },
                  text: 'NO'),
            ],
          ),
          SizedBox(
            // height: 100,
            width: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "ROCK",
                  style: TextStyle(
                    fontSize: 48,
                  ),
                ),
                IconButton(
                  iconSize: 150,
                  icon: const Icon(Icons.do_not_touch),
                  onPressed: () {
                    setState(() {
                      //  TODO this needs to be actual max bet idk how to figure it out tho
                      _kill = true;
                      _wager = "Shot";
                      _amount = 2;
                      _rock = true;
                      print('kill: $_kill, wager: $_wager, amount: $_amount');
                      _onSubmitBet();
                    });
                  },
                ),
              ],
            ),
          )
        ],
      );

      /// If the client does not have the current bet and the player has
      /// chosen kill, show the type and amount
    } else if (!_rock) {
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
            items:
                _filteredWagers.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          TextField(
            controller: _amountController,
            decoration: const InputDecoration(hintText: "Enter your wager"),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
              LimitRange(0, _maxAmt)
            ],
            onChanged: _onAmountChanged,
          ),
          WikButton(
            text: 'Submit Bet',
            onPressed: () {
              if (_canSubmit) {
                print('kill: $_kill, wager: $_wager, amount: $_amount');
                _onSubmitBet();
              } else {
                null;
              }
            },
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    //  Load our view model
    // final vm = ref.watch(roomViewModel);
    return Scaffold(
      appBar: const WikAppBar(text: 'BETTING...'),
      body: Center(
        child: Container(
            width: 300,
            height: 400,
            padding: const EdgeInsets.all(8.0),
            child: _buildBetting()),
      ),
    );
  }
}
