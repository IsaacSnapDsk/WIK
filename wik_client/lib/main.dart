import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wik_client/src/models/room.dart';
import 'package:wik_client/src/services/room_view_model.dart';
import 'package:wik_client/src/views/create_room_view.dart';
import 'package:wik_client/src/views/join_room_view.dart';
import 'package:wik_client/src/views/room_view.dart';

Future main() async {
  // Load our .env file
  await dotenv.load(fileName: ".env");
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'WILL IT KILL'),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  /// Our view model
  late RoomViewModel vm;

  ///  Keeps track of our current room
  late Room? _room;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //  Get our view model
      vm = ref.watch(roomViewModel);

      vm.subscribeToJoinRoomSuccess(context);
      vm.subscribeToCreateRoomSuccess(context);
    });
  }

  /// Returns a join room button if we already have a room, else provides options
  Widget _buildHomeButtons() {
    //  If we have a room, just return a simple button to take us to our room view
    if (_room != null) {
      return ElevatedButton(
        child: const Text("Return to Room"),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) {
              return const RoomView();
            },
          ),
        ),
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            child: const Text("Create a Room"),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) {
                  return const CreateRoomView();
                },
              ),
            ),
          ),
          ElevatedButton(
            child: const Text("Join a Room"),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) {
                  return const JoinRoomView();
                },
              ),
            ),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _room = ref.watch(roomViewModel).room;

    //  Our actual layout
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buildHomeButtons(),
        ),
      ),
    );
  }
}
