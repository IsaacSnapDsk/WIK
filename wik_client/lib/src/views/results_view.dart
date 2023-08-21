import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wik_client/src/services/room_view_model.dart';
import 'package:wik_client/src/models/room.dart';
import 'package:wik_client/src/models/player.dart';
import 'package:wik_client/src/models/bet.dart';

class Punishment {
  //  Constructor
  Punishment({
    required this.playerId,
    required this.playerName,
    required this.amount,
  });

  /// identifier for which player made the bet
  final String playerId;

  /// The name of the player
  final String playerName;

  /// If it is kill or not
  int amount;
}

class ResultsView extends ConsumerStatefulWidget {
  const ResultsView({super.key});

  // /// The current bet
  // final Bet currentBet;

  @override
  ConsumerState<ResultsView> createState() => _ResultsViewState();
}

class _ResultsViewState extends ConsumerState<ResultsView> {
  /// List of [Punishmnets] to be submited
  final List<Punishment> _punishments = [];

  /// List of other players
  final List _otherPlayers = [];

  /// The players current bet
  late Bet _currentBet;

  /// Local room instance
  late Room _room;

  /// Local player instance
  late Player _player;

  /// Determines if we can submit the form or not
  bool _canSubmit = false;

  /// Determines if the player won or not
  bool _win = false;

  @override
  void initState() {
    super.initState();

    for (var player in _otherPlayers) {
      _punishments.add(Punishment(
        playerId: player.playerId,
        playerName: player.name,
        amount: 0,
      ));
    }
  }

  //Calculates if the player can submit their bet
  void _calcCanSubmit() {
    setState(() {
      // Total punishment amount
      int total = 0;

      // Parse the _punishments and get total value
      for (final pun in _punishments) {
        total += pun.amount;
      }

      //  If ANY of our values are null, this is false
      final canSubmit = total == _currentBet.amount;

      //  Set our value to whether we are falsey or not
      _canSubmit = canSubmit;
    });
  }

  void _onPunishmentChanged(String value, int idx) {
    _punishments[idx].amount = value.isEmpty ? 0 : int.parse(value);

    _calcCanSubmit();
  }

  // Submits the bet to the server
  void _onSubmitPunishments() {
    final List punishmentsToSubmit = [];

    for (final punishment in _punishments) {
      if (punishment.amount > 0) {
        punishmentsToSubmit.add({
          "playerId": punishment.playerId,
          "type": _currentBet.type,
          "amount": punishment.amount,
        });
      }
    }

    //  Get our view model
    final vm = ref.watch(roomViewModel);

    //  Submit our bet
    // vm.submitPunishments(_room.id, _player.id, punishmentsToSubmit);
  }

  Widget _buildResults() {
    /// Get the current room and player from the view model
    /// to get the submited bet from the server
    _room = ref.watch(roomViewModel).room!;
    _player = ref.watch(roomViewModel).player!;

    /// Find the player's current bet from the list of bets
    /// in the current round
    final bets = _room.rounds[_room.currentRound].bets;
    for (final bet in bets) {
      if (bet.playerId == _player.id) {
        _currentBet = bet;
        break;
      }
    }

    /// Find the other players from the list of players
    /// in the current round
    final players = _room.players;
    for (final player in players) {
      if (player.id != _player.id) {
        _otherPlayers.add(player);
      }
    }

    if (_room.rounds[_room.currentRound].kill!) {
      if (_currentBet.kill) {
        _win = true;
      } else {
        _win = false;
      }
    } else {
      if (_currentBet.kill) {
        _win = false;
      } else {
        _win = true;
      }
    }

    if (_win) {
      return Column(children: [
        Text("You won! You get give ${_currentBet.amount} ${_currentBet.type}"),
        Column(children: [
          const Text("Select who you want to punish:"),
          for (int i = 0; i < _punishments.length; i++)
            _punshmentSelection(_punishments[i], i),
          ElevatedButton(
              onPressed: () => _canSubmit ? _onSubmitPunishments() : null,
              child: const Text("Submit Punishment")),
        ]),
      ]);
    } else {
      return const Text("You lost!");
    }
  }

  Widget _punshmentSelection(Punishment punishment, int idx) {
    return Row(children: [
      Card(child: Text(punishment.playerName)),
      Expanded(
        child: TextField(
          decoration: const InputDecoration(hintText: "Amount"),
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          onChanged: (e) => _onPunishmentChanged(e, idx),
        ),
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
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
