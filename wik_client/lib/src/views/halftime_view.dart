import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wik_client/src/models/game_master.dart';
import 'package:wik_client/src/services/room_view_model.dart';
import 'package:wik_client/src/models/room.dart';
import 'package:wik_client/src/models/player.dart';
import 'package:wik_client/src/models/bet.dart';
import 'package:wik_client/src/models/score.dart';
import 'package:wik_client/src/util/bet_limit_formatter.dart';
import 'package:wik_client/src/views/wik_appbar.dart';
import 'package:wik_client/src/widgets/wik_button.dart';

class HalftimeView extends ConsumerStatefulWidget {
  const HalftimeView({super.key});

  @override
  ConsumerState<HalftimeView> createState() => _HalfTimeViewState();
}

class _HalfTimeViewState extends ConsumerState<HalftimeView> {
  /// Map of [Player]s to their punishment amount
  final Map<String, int> _scores = {};

  /// Local [List] of other [Player]s in the room
  late List<Player> _otherPlayers;

  /// The players current bet
  late Bet _currentBet;

  late Room _room;

  late GameMaster? _gm;

  @override
  Widget build(BuildContext context) {
    /// Get the current room and player from the view model
    /// to get the submited bet from the server
    _room = ref.watch(roomViewModel).room!;
    _gm = ref.watch(roomViewModel).gameMaster;

    final vm = ref.watch(roomViewModel);

    return Scaffold(
      appBar: WikAppBar(text: 'HALF TIME...'),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              opacity: 0.3,
              repeat: ImageRepeat.repeat,
              image: NetworkImage(
                  'https://static-cdn.jtvnw.net/emoticons/v2/emotesv2_e043e7c81c964163b915e9cdbbbbd16f/animated/light/3.0'),
            ),
          ),
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text("ITS HALF TIME, GO FUCK AROUND OR DO WHATEVER YA WANT"),
              if (_gm != null)
                WikButton(
                  onPressed: () => vm.stopHalftime(_room.id, _gm!.id),
                  text: 'End Halftime',
                ),
            ],
          ),
        ),
      ),
    );
  }
}
