import 'package:json_annotation/json_annotation.dart';

//  This is required to generate the JSON conversions
part 'bet.g.dart';

///
/// A [Bet] only exists during the lifecycle of a game, eliminating the need to
/// maintain score externally.
///
/// Bets belong to [Rounds]
/// Bets belond to [Players]
///
@JsonSerializable()
class Bet {
  //  Constructor
  const Bet({
    required this.playerId,
    required this.kill,
    required this.type,
    required this.amount,
  });

  /// identifier for which player made the bet
  final String playerId;

  /// If it is kill or not
  final bool kill;

  /// The type of bet placed (drinks, bb, shots)
  final String type;

  /// A number representing bet amount
  final int amount;

  /// Connect the generated [_$BetFromJson] function to the `fromJson`
  /// factory.
  factory Bet.fromJson(Map<String, dynamic> json) => _$BetFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$BetToJson(this);
}
