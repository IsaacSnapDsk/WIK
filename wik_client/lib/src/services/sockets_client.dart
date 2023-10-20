import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SocketsClient {
  /// This maintains our actual Socket client connection to the server
  /// This can be null when a connection has not been established yet
  IO.Socket? clientSocket;

  /// This is a static reference to this instance of our SocketsClient
  /// this uses a singleton pattern to ensure that we only ever spin up
  /// 1 instance of this SocketsClient, to avoid multiple connections
  static final SocketsClient _instance = SocketsClient._init();

  SocketsClient._init();

  /// Responsible for connecting to our server and returning the socket's instance
  /// If the connection already exists, it just returns the existing connection
  // SocketsClient._init() {
  // //  Establish our client connection to the server
  // clientSocket = IO.io('http://${dotenv.env['HOST']}:3000', <String, dynamic>{
  //   //  We have to specify "websocket" under transports to allow connection via web
  //   'transports': ['websocket'],
  //   'autoConnect': false,
  // });

  // //  Conncet to our server
  // clientSocket!.connect();
  // }
  factory SocketsClient({required String identifier}) {
    _instance.clientSocket =
        IO.io('http://${dotenv.env['HOST']}', <String, dynamic>{
      //   //  We have to specify "websocket" under transports to allow connection via web
      'transports': ['websocket'],
      'autoConnect': false,
      'auth': {'identifier': identifier},
    });

    //  Conncet to our server
    _instance.clientSocket!.connect();

    return _instance;
  }

  // static SocketsClient get instance {
  //   //  We set our _instance to our socket connection
  //   //  The "??=" operator will only set this if _instance is null
  //   _instance ??= SocketsClient._init();

  //   //  Return our found instance
  //   //  The "!" operator is a null assertion stating that this will NOT be null
  //   return _instance!;
  // }
}
