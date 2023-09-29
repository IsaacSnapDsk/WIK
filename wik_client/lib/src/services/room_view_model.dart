import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wik_client/src/models/game_master.dart';
import 'package:wik_client/src/models/player.dart';
import 'package:wik_client/src/models/room.dart';
import 'package:wik_client/src/models/bet.dart';
import 'package:wik_client/src/models/score.dart';
import 'package:wik_client/src/services/sockets_service.dart';
import 'package:wik_client/src/services/sockets_subscriber.dart';

final viewModelInitialized = StateProvider<bool>((ref) {
  return false;
});

final roomViewModel = ChangeNotifierProvider((ref) {
  return RoomViewModel(
    ref: ref,
    socketsService: ref.read(socketsService),
  );
});

class RoomViewModel extends ChangeNotifier implements SocketsSubscriber {
  RoomViewModel({
    required this.ref,
    required this.socketsService,
  }) {
    //  Subscribe to our sockets service
    socketsService.subscribe(this);

    //  Refresh all of our data
    refresh();

    //  Set our initialized value to true
    ref.read(viewModelInitialized.notifier).state = true;

    return;
  }

  /// Our services
  final SocketsService socketsService;

  /// Our ref to reference other providers
  final Ref ref;

  /// Keeps track of our current room
  Room? room;

  /// Keeps track of our current player
  Player? player;

  /// Keeps track of our current game master
  GameMaster? gameMaster;

  /// Keeps track of our current punishment
  Score? currentPunishment;

  /// Initialize the state
  void init() => refresh();

  @override
  void refresh() {
    //  Get our data from our sockets service
    room = socketsService.room;
    player = socketsService.player;
    gameMaster = socketsService.gameMaster;
    currentPunishment = socketsService.currentPunishment;

    //  Notify all listeners
    notifyListeners();
  }

  /// Helpers
  List<Player> otherPlayers() {
    //  Grab our current player id
    final id = player!.id;

    //  Grab ALL other players in the current room
    final players = room!.players;

    //  Filter out our current player
    final otherPlayers = players.where((player) => player.id != id).toList();

    //  Return em :)
    return otherPlayers;
  }

  /// LISTENERS

  /// Subscribe to our "changeTurnSuccess" listener
  void subscribeToChangeTurnSuccessListener(BuildContext context) {
    socketsService.changeTurnSuccessListener(context);
  }

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

  //  Subscribe to the "subscribeTBetSuccess" listener
  void subscribeToBetSuccess(BuildContext context) {
    socketsService.betSuccessListener(context);
  }

  //  Subscribe to the "subscribeToSubmitScoresSuccess" listener
  void subscribeToSubmitScoresSuccess(BuildContext context) {
    socketsService.submitScoresSuccessListener(context);
  }

  void subscribeToPunishmentSuccess(BuildContext context) {
    socketsService.punishmentSuccessListener(context);
  }

  /// EVENTS

  //  Sends a "createRoom" event to the server
  void createRoom(String roomName, int maxRounds) {
    //  Tell our sockets service we want to create a room
    socketsService.createRoom(roomName, maxRounds);
  }

  //  Sends a "joinRoom" event to the server
  void joinRoom(String joinId, String nickname) {
    //  Tell our sockets service we want to join a room
    socketsService.joinRoom(joinId, nickname);
  }

  //  Sends a "nextRound" event to the server
  void nextRound(String roomId, String gmId) {
    //  This only ever gets fired when going from Final to Bettiner
    //  so we should reset our current punishment to null
    currentPunishment = null;
    notifyListeners();
    socketsService.nextRound(roomId, gmId);
  }

  // Sends a "bet" event to the server
  void submitBet(String roomId, Bet bet) {
    //  Tell our sockets service we want to bet
    socketsService.submitBet(roomId, bet);
  }

  //  Sends a "startGame" event to the server
  void startGame(String roomId, String gmId) {
    socketsService.startGame(roomId, gmId);
  }

  //  Sends a "stopBetting" event to the server
  void stopBetting(String roomId, String gmId) {
    socketsService.stopBetting(roomId, gmId);
  }

  //  Sends a "stopWaiting" event to the server
  void stopWaiting(String roomId, String gmId, bool kill) {
    socketsService.stopWaiting(roomId, gmId, kill);
  }

  //  Sends a "stopPunishing" event to the server
  void stopPunishing(String roomId, String gmId) {
    socketsService.stopPunishing(roomId, gmId);
  }

  //  Sends a "submitScores" event to the server
  void submitScores(String roomId, String playerId, List scores) {
    socketsService.submitScores(roomId, playerId, scores);
  }
}
