import 'package:json_annotation/json_annotation.dart';
import 'package:wik_client/src/models/player.dart';
import 'package:wik_client/src/models/round.dart';

//  This is required to generate the JSON conversions
part 'room.g.dart';

///
/// A [Room] only exists during the lifecycle of a game, eliminating the need to
/// maintain score externally.
///
/// Player belong to a single [Room]
/// Player has many [Vote]
///
@JsonSerializable()
class Room {
  Room({
    required this.id,
    required this.name,
    required this.maxRounds,
    required this.currentRound,
    required this.half,
    required this.players,
    required this.rounds,
  });

  /// Unique identifier for our room
  final String id;

  /// The name our room is displayed as
  final String name;

  /// The maximum number of rounds our game runs before ending
  final int maxRounds;

  /// The current index of our current round
  int currentRound;

  /// A bool value determining if we are in half time or not
  bool half;

  /// An array of the players in our game
  final List<Player> players;

  /// An array of the rounds in our game
  final List<Round> rounds;

  /// Connect the generated [_$RoomFromJson] function to the `fromJson`
  /// factory.
  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);

  /// Connect the generated [_$RoomToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$RoomToJson(this);
}
