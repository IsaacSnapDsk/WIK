import 'package:json_annotation/json_annotation.dart';

//  This is required to generate the JSON conversions
part 'game_master.g.dart';

///
/// A [GameMaster] maintains the state of the game, changing turns as needed
///
/// GameMaster belong to a single [Room]
///
@JsonSerializable()
class GameMaster {
  //  Constructor
  const GameMaster({
    required this.id,
    required this.roomId,
    required this.socketId,
    required this.secret,
  });

  /// Unique identifier for our player
  final String id;

  /// The id of the room our game master is in
  final String roomId;

  /// The ID of their socket connection, for maintaining connection
  final String socketId;

  /// A unique secret to verify the game master's connection
  final String secret;

  /// Connect the generated [_$GameMasterFromJson] function to the `fromJson`
  /// factory.
  factory GameMaster.fromJson(Map<String, dynamic> json) =>
      _$GameMasterFromJson(json);

  /// Connect the generated [_$GameMasterToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$GameMasterToJson(this);
}
