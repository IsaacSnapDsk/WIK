// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bet _$BetFromJson(Map<String, dynamic> json) => Bet(
      playerId: json['playerId'] as String,
      kill: json['kill'] as bool,
      type: json['type'] as String,
      amount: json['amount'] as int,
    );

Map<String, dynamic> _$BetToJson(Bet instance) => <String, dynamic>{
      'playerId': instance.playerId,
      'kill': instance.kill,
      'type': instance.type,
      'amount': instance.amount,
    };
