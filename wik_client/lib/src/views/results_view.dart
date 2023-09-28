import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wik_client/src/services/room_view_model.dart';
import 'package:wik_client/src/models/room.dart';
import 'package:wik_client/src/models/player.dart';
import 'package:wik_client/src/models/bet.dart';
import 'package:wik_client/src/models/score.dart';
import 'package:wik_client/src/views/wik_appbar.dart';
import 'package:wik_client/src/widgets/wik_button.dart';

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

  /// Determines if we have submitted or not
  bool _scoreSubmitted = false;

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
    vm.submitScores(_room.id, _player.id, scoresToSubmit);

    //  We've submitted so lets change our screen
    _scoreSubmitted = true;
  }

  Widget _buildLoss() {
    /// TODO make this meaner
    return const Text("You lost!");
  }

  Widget _buildResults() {
    //  If we have submitted, just return a success message
    if (_scoreSubmitted) return _buildSuccess();

    //  We can give them a nice layout
    return Column(
      children: [
        Text(
            "You won! You get to give ${_currentBet.amount} ${_currentBet.type}${_currentBet.amount > 1 ? 's' : ''}"),
        Column(
          children: [
            const Text("Select who you want to punish:"),
            for (var player in _otherPlayers) _punshmentSelection(player),
            WikButton(
              onPressed: () => _canSubmit ? _onSubmitPunishments() : null,
              text: "Submit Punishment",
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSuccess() {
    //  Get the players we are fucking up
    final players = _otherPlayers.where((x) => _scores.containsKey(x.id));

    return Center(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              "Yor current punishments:",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
                fontWeight: FontWeight.bold,
                fontSize: Theme.of(context).textTheme.headlineSmall!.fontSize,
              ),
            ),
            for (Player player in players)
              Column(
                children: [
                  Text(
                    player.name,
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize:
                          Theme.of(context).textTheme.headlineSmall!.fontSize,
                    ),
                  ),
                  Text(
                    "${_scores[player.id]} ${_currentBet.type}",
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize:
                          Theme.of(context).textTheme.headlineSmall!.fontSize,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Bet? _getCurrentBet() {
    // Find the player's current bet from the list of bets
    /// in the current round
    final bets = _room.rounds[_room.currentRound].bets;

    //  Iterate through each bet to find our current one
    for (final bet in bets) {
      //  Once our bet is found that matches our current player, return it
      if (bet.playerId == _player.id) {
        return bet;
      }
    }

    //  If we somehow get down here, return null
    //  Theoretically, should never happen
    return null;
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

    //  Find our current bet from the list of bets in the round
    _currentBet = _getCurrentBet()!;

    //  We won if our current bet matches the current round's bet
    _win = _room.rounds[_room.currentRound].kill! == _currentBet.kill;

    return Scaffold(
      appBar: const WikAppBar(text: 'RESULTS...'),
      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                "Your current bet:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,
                ),
              ),
              Text(
                'The clip was: ${_room.rounds[_room.currentRound].kill! ? "Kill" : "No Kill"}',
                style: TextStyle(
                  color: _win ? Colors.blueAccent : Colors.pink,
                ),
              ),
              if (!_win) _buildLoss() else _buildResults(),
            ],
          ),
        ),
      ),
    );
  }
}
