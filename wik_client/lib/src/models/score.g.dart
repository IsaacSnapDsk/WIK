// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'score.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Score _$ScoreFromJson(Map<String, dynamic> json) => Score(
      playerId: json['playerId'] as String,
      win: json['win'] as int,
      drinks: json['drinks'] as int,
      shots: json['shots'] as int,
      bb: json['bb'] as int,
    );

Map<String, dynamic> _$ScoreToJson(Score instance) => <String, dynamic>{
      'playerId': instance.playerId,
      'win': instance.win,
      'drinks': instance.drinks,
      'shots': instance.shots,
      'bb': instance.bb,
    };
