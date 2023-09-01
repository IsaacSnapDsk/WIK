import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:wik_client/src/models/room.dart';
import 'package:wik_client/src/models/game_master.dart';
import 'package:wik_client/src/models/player.dart';
import 'package:wik_client/src/models/bet.dart';
import 'package:wik_client/src/services/sockets_client.dart';
import 'package:wik_client/src/services/sockets_subscriber.dart';

final socketsService = Provider((ref) => SocketsService(ref));

class SocketsService {
  SocketsService(this.ref);

  /// This is our ref that we use to gain access to our RoomViewModel
  final Ref ref;

  /// This is our current client socket
  final Socket _client = SocketsClient.instance.clientSocket!;

  /// Variables for our game state
  Room? _room;
  Player? _player;
  GameMaster? _gameMaster;

  /// A list of our subscribers to listen to our events
  static List<SocketsSubscriber> subscribers = [];

  //  Subscribes a subscriber to listen for our events
  Future<void> subscribe(SocketsSubscriber subscriber) async {
    subscribers.add(subscriber);
  }

  /// Getters for our game state variables
  Room? get room => _room;
  Player? get player => _player;
  GameMaster? get gameMaster => _gameMaster;

  void notifySubscribers() {
    //  Iterate through each subscriber and tell them to refresh
    for (final subscriber in subscribers) {
      subscriber.refresh();
    }
  }

  /// SOCKET EMITS

  //  Sends a "createRoom" event to our Server
  void createRoom(String roomName, int maxRounds) {
    _client.emit(
      'createRoom',
      {
        'roomName': roomName,
        'maxRounds': maxRounds,
      },
    );
  }

  //  Sends a "joinRoom" event to our Server
  void joinRoom(String joinId, String nickname) {
    _client.emit(
      'joinRoom',
      {
        'joinId': joinId,
        'nickname': nickname,
      },
    );
  }

  //  Sends a "submitBet" event to our Server
  void submitBet(String roomId, Bet bet) {
    _client.emit(
      'submitBet',
      {
        'roomId': roomId,
        'bet': bet,
      },
    );
  }

  /// Sends a "startGame" event to our Server
  void startGame(String roomId, String gmId) {
    _client.emit(
      'startGame',
      {
        'roomId': roomId,
        'gmId': gmId,
      },
    );
  }

  /// Sends a "stopBetting" event to ur Server
  void stopBetting(String roomId, String gmId) {
    _client.emit(
      'stopBetting',
      {
        'roomId': roomId,
        'gmId': gmId,
      },
    );
  }

  /// Sends a "stopWaiting" event to ur Server
  void stopWaiting(String roomId, String gmId, bool kill) {
    _client.emit(
      'stopWaiting',
      {
        'roomId': roomId,
        'gmId': gmId,
        'kill': kill,
      },
    );
  }

  /// Sends a "submitPunishment" event to our Server
  void submitPunishment(String roomId, String playerId, List punishment) {
    _client.emit(
      'submitPunishment',
      {
        'roomId': roomId,
        'playerId': playerId,
        'punishment': punishment,
      },
    );
  }

  /// SOCKET LISTENERS

  /// Listens to the "changeTurnSuccess" event
  void changeTurnSuccessListener(BuildContext context) {
    _client.on('changeTurnSuccess', (response) {
      //  Create our room
      _room = Room.fromJson(response);

      //  Tell our subscribes to refresh
      notifySubscribers();
    });
  }

  /// Listens to the "createRoomSuccess" event
  void createRoomSuccessListener(BuildContext context) {
    _client.on('createRoomSuccess', (response) {
      //  Create our room
      _room = Room.fromJson(response);

      //  Tell our subscribers to refresh
      notifySubscribers();
    });
  }

  /// Listenes to the "gameMasterCreatedSuccess" event
  void gameMasterCreatedSuccess(BuildContext context) {
    _client.on('gameMasterCreatedSuccess', (response) {
      //  Convert our response into a game master
      _gameMaster = GameMaster.fromJson(response);

      //  Tell our subscribers to refresh
      notifySubscribers();
    });
  }

  /// Listens to the "joinRoomSuccess" event
  void joinRoomSuccessListener(BuildContext context) {
    _client.on('joinRoomSuccess', (response) {
      //  Convert our room into a room
      _room = Room.fromJson(response);

      //  Tell our subscribers to refresh
      notifySubscribers();
    });
  }

  /// Listens to our "playerCreatedSuccess" event
  void playerCreatedSuccessListener(BuildContext context) {
    _client.on('playerCreatedSuccess', (response) {
      //  Convert our player into a player
      _player = Player.fromJson(response);

      //  Tell our subscribers to refresh
      notifySubscribers();
    });
  }

  /// Listens to the "startGameSuccess" event
  void startGameSuccessListener(BuildContext context) {
    _client.on("startGameSuccess", (response) {
      //  Convert our room to an actual room
      _room = Room.fromJson(response);

      //  Tell our subscribers to refresh
      notifySubscribers();
    });
  }

  /// Listens to the "betSuccess" event
  void betSuccessListener(BuildContext context) {
    _client.on('betSuccess', (response) {
      //  Convert our players into players
      _room = Room.fromJson(response);

      //  Tell our subscribers to refresh
      notifySubscribers();
    });
  }

  /// Listens to the "betSuccess" event
  void punishmentSuccessListener(BuildContext context) {
    _client.on('punismentSuccess', (response) {
      //  Convert our players into players
      _room = Room.fromJson(response);

      //  Tell our subscribers to refresh
      notifySubscribers();
    });
  }
}
