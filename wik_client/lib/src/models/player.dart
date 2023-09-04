import 'package:json_annotation/json_annotation.dart';
import 'package:wik_client/src/models/bet.dart';
import 'package:wik_client/src/models/score.dart';

//  This is required to generate the JSON conversions
part 'player.g.dart';

///
/// A [Player] only exists during the lifecycle of a game, eliminating the need to
/// maintain score externally.
///
/// Player belong to a single [Room]
/// Player has many [Vote]
///
@JsonSerializable()
class Player {
  //  Constructor
  Player({
    required this.id,
    required this.name,
    required this.socketId,
    required this.wins,
    required this.drinks,
    required this.shots,
    required this.bb,
    required this.bets,
    required this.scores,
    required this.punished,
  });

  /// Unique identifier for our player
  final String id;

  /// The name our player is displayed as
  final String name;

  /// The ID of their socket connection, for maintaining connection
  final String socketId;

  /// A number representing their total number of wins for this player during this game
  int wins;

  /// A number representing their total number of drinks for htis player during this game
  int drinks;

  /// A number representing their total number of shots for htis player during this game
  int shots;

  /// A number representing their total number of bbs for htis player during this game
  int bb;

  /// A list of a player's bets
  final List<Bet> bets;

  /// A list of a player's scores
  final List<Score> scores;

  /// A boolean value telling us if the player has submitted a punishment
  bool punished;

  /// Connect the generated [_$PlayerFromJson] function to the `fromJson`
  /// factory.
  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$PlayerToJson(this);
}
