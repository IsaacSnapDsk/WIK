import 'package:json_annotation/json_annotation.dart';

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
    required this.kill,
    required this.turn,
    // this.vote,
  });

  /// Unique identifier for our room
  final String id;

  /// The name our round is displayed as
  final int no;

  /// A bool value that determines if this round was a kill or not
  final bool kill;

  /// An enum value representing what our current turn is
  String turn;

  /// Connect the generated [_$RoundFromJson] function to the `fromJson`
  /// factory.
  factory Round.fromJson(Map<String, dynamic> json) => _$RoundFromJson(json);

  /// Connect the generated [_$RoundToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$RoundToJson(this);
}
