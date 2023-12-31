// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'round.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Round _$RoundFromJson(Map<String, dynamic> json) => Round(
      id: json['_id'] as String,
      no: json['no'] as int,
      kill: json['kill'] as bool?,
      half: json['half'] as bool?,
      punishments: json['punishments'] as int?,
      turn: json['turn'] as String,
      bets: (json['bets'] as List<dynamic>)
          .map((e) => Bet.fromJson(e as Map<String, dynamic>))
          .toList(),
      scores: (json['scores'] as List<dynamic>)
          .map((e) => Score.fromJson(e as Map<String, dynamic>))
          .toList(),
      winners: (json['winners'] as List<dynamic>)
          .map((e) => Player.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RoundToJson(Round instance) => <String, dynamic>{
      'id': instance.id,
      'no': instance.no,
      'kill': instance.kill,
      'turn': instance.turn,
      'bets': instance.bets,
      'scores': instance.scores,
      'winners': instance.winners,
    };
