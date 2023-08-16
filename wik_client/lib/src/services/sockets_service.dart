import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:wik_client/src/services/sockets_client.dart';

class SocketsService {
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

  // void tapGrid(int index, String roomId, List<String> displayElements) {
  //   if (displayElements[index] == '') {
  //     _socketClient.emit('tap', {
  //       'index': index,
  //       'roomId': roomId,
  //     });
  //   }
  // }

  /// SOCKET LISTENERS
  // void createRoomSuccessListener(BuildContext context) {
  //   _socketClient.on('createRoomSuccess', (room) {
  //     Provider.of<RoomDataProvider>(context, listen: false)
  //         .updateRoomData(room);
  //     Navigator.pushNamed(context, GameScreen.routeName);
  //   });
  // }

  /// Test listener
  /// This will listen to "testSuccess" events from our server and then
  /// print to the console the message received
  void testSuccessListener(BuildContext context) {
    _client.on(
      'testSuccess',
      (message) {
        /// TODO hook this up to riverpod so flutter pages can receive data
        print("client test success: $message");
      },
    );
  }
}
