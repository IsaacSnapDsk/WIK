import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wik_client/src/models/game_master.dart';
import 'package:wik_client/src/models/player.dart';
import 'package:wik_client/src/models/room.dart';
import 'package:wik_client/src/models/bet.dart';
import 'package:wik_client/src/services/sockets_service.dart';
import 'package:wik_client/src/services/sockets_subscriber.dart';

final roomViewModel = ChangeNotifierProvider((ref) {
  return RoomViewModel(
    socketsService: ref.read(socketsService),
  );
});

class RoomViewModel extends ChangeNotifier implements SocketsSubscriber {
  RoomViewModel({
    required this.socketsService,
  }) {
    //  Subscribe to our sockets service
    socketsService.subscribe(this);

    //  Refresh all of our data
    refresh();

    return;
  }

  /// Our services
  final SocketsService socketsService;

  /// Keeps track of our current room
  Room? room;

  /// Keeps track of our current player
  Player? player;

  /// Keeps track of our current game master
  GameMaster? gameMaster;

  /// Initialize the state
  void init() => refresh();

  @override
  void refresh() {
    //  Get our data from our sockets service
    room = socketsService.room;
    player = socketsService.player;
    gameMaster = socketsService.gameMaster;

    //  Notify all listeners
    notifyListeners();
  }

  /// LISTENERS

  //  Subscribe to our "createRoomSuccess" listener
  void subscribeToCreateRoomSuccess(BuildContext context) {
    socketsService.createRoomSuccessListener(context);
  }

  //  Subscribe to the "gameMasterCreatedSuccess" listener
  void subscribeToGameMasterCreatedSuccess(BuildContext context) {
    socketsService.gameMasterCreatedSuccess(context);
  }

  //  Subscribe to the "playerCreatedSuccess" listener
  void subscribeToPlayerCreatedSuccess(BuildContext context) {
    socketsService.playerCreatedSuccessListener(context);
  }

  //  Subscribe to the "joinRoomSuccess" listener
  void subscribeToJoinRoomSuccess(BuildContext context) {
    socketsService.joinRoomSuccessListener(context);
  }

  //  Subscribe to the "startGameSuccess" listener
  void subscribeToStartGameSuccess(BuildContext context) {
    socketsService.startGameSuccessListener(context);
  }

  /// EVENTS

  //  Sends a "createRoom" event to the server
  void createRoom(String roomName, int maxRounds) {
    //  Tell our sockets service we want to create a room
    socketsService.createRoom(roomName, maxRounds);
  }

  //  Sends a "joinRoom" event to the server
  void joinRoom(String roomId, String nickname) {
    //  Tell our sockets service we want to join a room
    socketsService.joinRoom(roomId, nickname);
  }

  // Sends a "bet" event to the server
  void submitBet(String roomId, Bet bet) {
    //  Tell our sockets service we want to bet
    socketsService.bet(roomId, bet);
  }

  //  Sends a "startGame" event to the server
  void startGame(String roomId, String gmId) {
    socketsService.startGame(roomId, gmId);
  }
}
