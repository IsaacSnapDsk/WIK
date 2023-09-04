// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Player _$PlayerFromJson(Map<String, dynamic> json) => Player(
      id: json['_id'] as String,
      name: json['name'] as String,
      socketId: json['socketId'] as String,
      wins: json['wins'] as int,
      drinks: json['drinks'] as int,
      shots: json['shots'] as int,
      bb: json['bb'] as int,
      bets: (json['bets'] as List<dynamic>)
          .map((e) => Bet.fromJson(e as Map<String, dynamic>))
          .toList(),
      scores: (json['scores'] as List<dynamic>)
          .map((e) => Score.fromJson(e as Map<String, dynamic>))
          .toList(),
      punished: json['punished'] as bool,
    );

Map<String, dynamic> _$PlayerToJson(Player instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'socketId': instance.socketId,
      'wins': instance.wins,
      'drinks': instance.drinks,
      'shots': instance.shots,
      'bb': instance.bb,
      'punished': instance.punished,
    };
