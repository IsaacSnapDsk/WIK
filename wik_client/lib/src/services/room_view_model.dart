import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wik_client/src/models/room.dart';
import 'package:wik_client/src/services/sockets_service.dart';

final roomViewModel = ChangeNotifierProvider((ref) {
  return RoomViewModel(
    socketsService: ref.read(socketsService),
  );
});

class RoomViewModel extends ChangeNotifier {
  RoomViewModel({
    required this.socketsService,
  }) {
    return;
  }

  final SocketsService socketsService;

  String test = "Waiting";

  //  Keeps track of our current room
  Room? room;

  /// LISTENERS

  //  Subscribe to our "testSuccess" listener
  void subscribeToTestSuccess(BuildContext context) {
    socketsService.testSuccessListener(context);
  }

  //  Subscribe to our "createRoomSuccess" listener
  void subscribeToCreateRoomSuccess(BuildContext context) {
    socketsService.createRoomSuccessListener(context);
  }

  //  Subscribe to the "joinRoomSuccess" listener
  void subscribeToJoinRoomSuccess(BuildContext context) {
    socketsService.joinRoomSuccessListener(context);
  }

  /// EVENT HANDLERS

  //  Handles our "onTestSuccess" event from Sockets Service
  void onTestSuccess(String message) {
    //  Set our test value
    test = message;

    //  Notify listeners about this
    notifyListeners();
  }

  //  Handles our "createRoomSuccess" event from Sockets Service
  void joinRoomSuccess(Room newRoom) {
    //  Set our room
    // room = newRoom;

    //  Notify all listeners
    notifyListeners();
  }

  //  Handles our "createRoomSuccess" event from Sockets Service
  //  TODO fix this
  void createRoomSuccess() {
    //  Set our room
    // room = newRoom;

    //  Notify all listeners
    notifyListeners();
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
}
