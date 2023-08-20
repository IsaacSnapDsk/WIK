import 'package:json_annotation/json_annotation.dart';

//  This is required to generate the JSON conversions
part 'score.g.dart';

///
/// A [Score] only exists during the lifecycle of a game, eliminating the need to
/// maintain score externally.
///
/// Score belongs to a single [Player] and a single [Round]
///
@JsonSerializable()
class Score {
  //  Constructor
  const Score({
    required this.playerId,
    required this.win,
    required this.drinks,
    required this.shots,
    required this.bb,
  });

  /// Unique identifier for our player
  final String playerId;

  /// A number representing if the player won for this round or not
  final int win;

  /// A number representing their total number of drinks for htis player during this round
  final int drinks;

  /// A number representing their total number of shots for htis player during this round
  final int shots;

  /// A number representing their total number of bbs for htis player during this round
  final int bb;

  /// Connect the generated [_$ScoreFromJson] function to the `fromJson`
  /// factory.
  factory Score.fromJson(Map<String, dynamic> json) => _$ScoreFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$ScoreToJson(this);
}
