import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wik_client/src/models/game_master.dart';
import 'package:wik_client/src/models/room.dart';
import 'package:wik_client/src/services/room_view_model.dart';
import 'package:wik_client/src/views/betting_view.dart';
import 'package:wik_client/src/views/game_master_betting_view.dart';
import 'package:wik_client/src/views/game_master_results_view.dart';
import 'package:wik_client/src/views/game_master_waiting_view.dart';
import 'package:wik_client/src/views/punishment_view.dart';
import 'package:wik_client/src/views/results_view.dart';
import 'package:wik_client/src/views/scoreboard_view.dart';

class StartedRoomView extends ConsumerStatefulWidget {
  const StartedRoomView({super.key});

  @override
  ConsumerState<StartedRoomView> createState() => _StartedRoomViewState();
}

class _StartedRoomViewState extends ConsumerState<StartedRoomView> {
  late GameMaster? _gameMaster;
  late Room _room;

  /// Our view model
  late RoomViewModel vm;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      //  Get our view model
      vm = ref.watch(roomViewModel);

      //  Subscribe to having successful bets be sent
      vm.subscribeToBetSuccess(context);

      //  Subscribe to turn change events
      vm.subscribeToSubmitScoresSuccess(context);

      //  Subscribe to punishment success events
      vm.subscribeToPunishmentSuccess(context);
    });
  }

  Widget _buildGameMasterView() {
    //  Grab our current round
    final currentRound = _room.rounds[_room.currentRound];

    //  Get our view model
    vm = ref.watch(roomViewModel);

    //  The view depends on what phase we are in
    switch (currentRound.turn) {
      case 'Betting':
        return GameMasterBettingView(
          round: currentRound,
          players: _room.players,
          onStopBetting: () => vm.stopBetting(_room.id, _gameMaster!.id),
        );
      case 'Waiting':
        return GameMasterWaitingView(
          onStopWaiting: (bool val) =>
              vm.stopWaiting(_room.id, _gameMaster!.id, val),
        );
      case 'Results':
        return GameMasterResultsView(
          players: _room.players,
          round: currentRound,
          onStopPunishing: () => vm.stopPunishing(_room.id, _gameMaster!.id),
        );
      case 'Final':
        return const ScoreboardView();
      default:
        return _buildPlaceholder();
      // case 'Resulting':
      //   return const GameMasterResultingView();
      // case 'Final':
      //   return const GameMasterFinalView();
    }
  }

  Widget _buildPlaceholder() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text("Some shit broke"),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: const Text("SOMETHING BROKE"),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //  Grab our room
    _room = ref.watch(roomViewModel).room!;

    //  Check if we are the game master or not
    _gameMaster = ref.watch(roomViewModel).gameMaster;

    //  If our game master is null then return our placeholder
    if (_gameMaster != null) return _buildGameMasterView();

    //  Grab our current round
    final currentRound = _room.rounds[_room.currentRound];

    //  Return a view based on what phase we are in
    switch (currentRound.turn) {
      case 'Betting':
        return const BettingView();
      case 'Waiting':
        return const BettingView();
      case 'Results':
        return const ResultsView();
      case 'Final':
        return const PunishmentView();
      default:
        return _buildPlaceholder();
    }
  }
}
