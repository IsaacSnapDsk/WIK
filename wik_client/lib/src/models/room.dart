import 'package:wik_client/src/models/player.dart';

class Room {
  const Room({
    required this.id,
    required this.name,
    required this.maxRounds,
    required this.currentRound,
    required this.half,
    required this.players,
  });

  final String id;
  final String name;
  final int maxRounds;
  final int currentRound;
  final bool half;
  final List<Player> players;
}
