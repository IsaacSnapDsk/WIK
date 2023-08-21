import 'package:json_annotation/json_annotation.dart';
import 'package:wik_client/src/models/bet.dart';
import 'package:wik_client/src/models/score.dart';

//  This is required to generate the JSON conversions
part 'round.g.dart';

///
/// A [Round] only exists during the lifecycle of a game, and belongs to
/// a [Room].
///
/// Round belong to a single [Room]
/// Round has many [Vote]
///
@JsonSerializable()
class Round {
  //  Constructor
  Round({
    required this.id,
    required this.no,
    this.kill,
    required this.turn,
    required this.half,
    this.punishments,
    required this.bets,
    required this.scores,
  });

  /// Unique identifier for our room
  final String id;

  /// The name our round is displayed as
  final int no;

  /// A bool value that determines if this round was a kill or not
  final bool? kill;

  /// A bool value that determines if we in half time or not
  final bool? half;

  /// A number for the number of punishments to be dished out, starts at 0
  final int? punishments;

  /// An enum value representing what our current turn is
  String turn;

  /// A list of a round's bets
  final List<Bet> bets;

  /// A list of a round's scores
  final List<Score> scores;

  /// Connect the generated [_$RoundFromJson] function to the `fromJson`
  /// factory.
  factory Round.fromJson(Map<String, dynamic> json) => _$RoundFromJson(json);

  /// Connect the generated [_$RoundToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$RoundToJson(this);
}
