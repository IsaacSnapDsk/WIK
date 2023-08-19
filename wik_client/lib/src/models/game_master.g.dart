// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_master.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameMaster _$GameMasterFromJson(Map<String, dynamic> json) => GameMaster(
      id: json['_id'] as String,
      roomId: json['roomId'] as String,
      socketId: json['socketId'] as String,
      secret: json['secret'] as String,
    );

Map<String, dynamic> _$GameMasterToJson(GameMaster instance) =>
    <String, dynamic>{
      'id': instance.id,
      'roomId': instance.roomId,
      'socketId': instance.socketId,
      'secret': instance.secret,
    };
