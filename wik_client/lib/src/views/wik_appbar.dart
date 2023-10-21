import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wik_client/src/models/game_master.dart';
import 'package:wik_client/src/models/room.dart';
import 'package:wik_client/src/services/room_view_model.dart';

class WikAppBar extends ConsumerWidget implements PreferredSizeWidget {
  WikAppBar({this.text, super.key});

  final String? text;

  GameMaster? _gm;

  Room? _room;

  RoomViewModel? _vm;

  @override
  final Size preferredSize = const Size.fromHeight(kToolbarHeight);

  /// Builds our list of menu items based on our _items variable
  List<Widget> _buildMenuChildren() {
    return List<Widget>.generate(
      _room!.players.length,
      (int idx) {
        return MenuItemButton(
          child: SizedBox(
            width: 150,
            child: Row(
              children: [
                Icon(
                  Icons.circle,
                  color: _room!.players[idx].connected
                      ? Colors.blueAccent
                      : Colors.pink,
                ),
                Text(_room!.players[idx].name),
                IconButton(
                  icon: const Icon(
                    Icons.cancel,
                    color: Colors.pink,
                  ),
                  onPressed: () => _vm!
                      .removePlayer(_room!.id, _gm!.id, _room!.players[idx].id),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlayerList() {
    return MenuAnchor(
      builder: (context, controller, child) {
        return InputChip(
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          label: const Row(
            children: [
              Icon(Icons.expand_more),
              Text("Players"),
            ],
          ),
        );
      },
      menuChildren: _buildMenuChildren(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //  Check if our view model is initialized yet
    final initialized = ref.watch(viewModelInitialized);

    //  If we're initialized, set our vm
    if (initialized) {
      _vm = ref.watch(roomViewModel);
      _room = _vm!.room;
      _gm = _vm!.gameMaster;
    }

    return AppBar(
      leadingWidth: 70,
      leading: _room != null
          ? Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.75),
              ),
              child: Column(
                children: [
                  const Text(
                    "JOIN ID:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    _room!.joinId,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent[100],
                    ),
                  ),
                ],
              ),
            )
          : null,
      flexibleSpace: const Image(
        fit: BoxFit.fitWidth,
        image: NetworkImage(
            'https://assets-prd.ignimgs.com/2022/08/10/top10fighting-1660091625986.jpg'),
      ),
      iconTheme: const IconThemeData(
        color: Colors.white, //change your color here
      ),
      title: Container(
        padding: const EdgeInsets.all(6.0),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.75),
          border: Border.all(
            color: Colors.white,
            width: 3,
          ),
        ),
        child: Text(
          text ?? "WILL IT KILL...?",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            shadows: [
              Shadow(
                offset: const Offset(0, 5),
                color: Theme.of(context).colorScheme.primary,
              )
            ],
          ),
        ),
      ),
      actions: _room != null && _gm != null
          ? [
              _buildPlayerList(),
            ]
          : null,
    );
  }
}
