import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wik_client/src/services/room_view_model.dart';
import 'package:wik_client/src/models/room.dart';
import 'package:wik_client/src/models/player.dart';
import 'package:wik_client/src/models/bet.dart';
import 'package:wik_client/src/models/score.dart';

class ResultsView extends ConsumerStatefulWidget {
  const ResultsView({super.key});

  @override
  ConsumerState<ResultsView> createState() => _ResultsViewState();
}

class _ResultsViewState extends ConsumerState<ResultsView> {
  /// Map of [Player]s to their punishment amount
  final Map<String, int> _scores = {};

  /// Local [List] of other [Player]s in the room
  late List<Player> _otherPlayers;

  /// Local [Player] instance
  late Player _player;

  /// The players current bet
  late Bet _currentBet;

  /// Local room instance
  late Room _room;

  /// Determines if we can submit the form or not
  bool _canSubmit = false;

  /// Determines if the player won or not
  bool _win = false;

  //Calculates if the player can submit their bet
  void _calcCanSubmit() {
    setState(() {
      // Total punishment amount
      int total = _scores.values.reduce((a, b) => a + b);

      //  If ANY of our values are null, this is false
      final canSubmit = total == _currentBet.amount;

      //  Set our value to whether we are falsey or not
      _canSubmit = canSubmit;
    });
  }

  void _onPunishmentChanged(String value, String playerId) {
    _scores[playerId] = value.isEmpty ? 0 : int.parse(value);

    _calcCanSubmit();
  }

  // Submits the bet to the server
  void _onSubmitPunishments() {
    final List<Score> scoresToSubmit = [];

    //  Check if we
    final type = _currentBet.type;

    _scores.forEach((id, amt) {
      scoresToSubmit.add(Score(
        playerId: id,
        drinks: type == 'Drink' ? amt : 0,
        shots: type == 'Shot' ? amt : 0,
        bb: type == 'BB' ? amt : 0,
      ));
    });

    //  Get our view model
    final vm = ref.watch(roomViewModel);

    //  Submit our bet
    vm.submitScores(_room.id, scoresToSubmit);
  }

  Widget _buildResults() {
    /// Find the player's current bet from the list of bets
    /// in the current round
    final bets = _room.rounds[_room.currentRound].bets;
    for (final bet in bets) {
      if (bet.playerId == _player.id) {
        _currentBet = bet;
        break;
      }
    }

    _win = _room.rounds[_room.currentRound].kill! == _currentBet.kill;

    if (_win) {
      return Column(children: [
        Text("You won! You get give ${_currentBet.amount} ${_currentBet.type}"),
        Column(children: [
          const Text("Select who you want to punish:"),
          for (var player in _otherPlayers) _punshmentSelection(player),
          ElevatedButton(
              onPressed: () => _canSubmit ? _onSubmitPunishments() : null,
              child: const Text("Submit Punishment")),
        ]),
      ]);
    } else {
      return const Text("You lost!");
    }
  }

  Widget _punshmentSelection(Player player) {
    /// Find the other players from the list of players
    /// in the current round
    return Row(children: [
      Card(child: Text(player.name)),
      Expanded(
        child: TextField(
          decoration: const InputDecoration(hintText: "Amount"),
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          onChanged: (e) => _onPunishmentChanged(e, player.id),
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    /// Get the current room and player from the view model
    /// to get the submited bet from the server
    _room = ref.watch(roomViewModel).room!;
    _player = ref.watch(roomViewModel).player!;
    _otherPlayers = ref.watch(roomViewModel).otherPlayers();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text("Results"),
      ),
      body: Center(
        child: Container(
            width: 300,
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              const Text("Your current bet:"),
              Text(
                  'The clip was: ${_room.rounds[_room.currentRound].kill! ? "Kill" : "No Kill"}'),
              _buildResults(),
            ])),
      ),
    );
  }
}
