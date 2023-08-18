import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:wik_client/src/models/player.dart';
import 'package:wik_client/src/models/room.dart';
import 'package:wik_client/src/services/room_view_model.dart';
import 'package:wik_client/src/services/sockets_client.dart';

final socketsService = Provider((ref) => SocketsService(ref));

class SocketsService {
  SocketsService(this.ref);

  /// This is our ref that we use to gain access to our RoomViewModel
  final Ref ref;

  /// This is our current client socket
  final Socket _client = SocketsClient.instance.clientSocket!;

  /// SOCKET EMITS

  /// Test event
  /// This send a "test" event to the Server along with whatever message we incldue
  void test(String message) {
    _client.emit(
      'test',
      {'message': message},
    );
  }

  void createRoom(String roomName, String nickname, int maxRounds) {
    _client.emit('createRoom', {'roomName': roomName});
  }

  /// SOCKET LISTENERS

  /// Test listener
  /// This will listen to "testSuccess" events from our server and then
  /// print to the console the message received
  void testSuccessListener(BuildContext context) {
    _client.on(
      'testSuccess',
      (message) {
        //  Grab our room view model
        final vm = ref.watch(roomViewModel);

        //  Inform our view model about the event
        vm.onTestSuccess(message);

        /// TODO hook this up to riverpod so flutter pages can receive data
        print("client test success: $message");
      },
    );
  }

  /// Listens to the "createRoomSuccess" event
  void createRoomSuccessListener(BuildContext context) {
    _client.on('createRoomSuccess', (response) {
      //  Grab our room view model
      final vm = ref.watch(roomViewModel);

      //  Convert our players into players
      final List<Player> players = [];

      //  Iterate through the players
      for (var player in response['players']) {
        players.add(
          Player(
            id: player['_id'] as String,
            wins: player['wins'] as int,
            shots: player['shots'] as int,
            bb: player['bb'] as int,
            drinks: player['drinks'] as int,
          ),
        );
      }

      //  Convert our room from json into an actual room
      final room = Room(
        // id: response['id'] as String,
        id: response['_id'] as String,
        name: response['name'] as String,
        maxRounds: response['maxRounds'] as int,
        currentRound: response['currentRound'] as int,
        half: response['half'] as int == 1 ? true : false,
        players: players,
        // players: [],
        // id: response['_id'] as String,
        // players: response['players'] as String?,
        // createdAt: DateTime.parse(response['createdAt'] as String),
      );

      //  Inform our view model about the event
      vm.createRoomSuccess(room);
    });
  }
}
