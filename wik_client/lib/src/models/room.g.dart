// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Room _$RoomFromJson(Map<String, dynamic> json) => Room(
      id: json['_id'] as String,
      joinId: json['joinId'] as String,
      name: json['name'] as String,
      maxRounds: json['maxRounds'] as int,
      currentRound: json['currentRound'] as int,
      half: json['half'] as bool,
      started: json['started'] as bool,
      players: (json['players'] as List<dynamic>)
          .map((e) => Player.fromJson(e as Map<String, dynamic>))
          .toList(),
      rounds: (json['rounds'] as List<dynamic>)
          .map((e) => Round.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RoomToJson(Room instance) => <String, dynamic>{
      'id': instance.id,
      'joinId': instance.joinId,
      'name': instance.name,
      'maxRounds': instance.maxRounds,
      'currentRound': instance.currentRound,
      'half': instance.half,
      'started': instance.started,
      'players': instance.players,
      'rounds': instance.rounds,
    };
