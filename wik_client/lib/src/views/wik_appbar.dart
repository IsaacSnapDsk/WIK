import 'package:flutter/material.dart';

class WikAppBar extends StatelessWidget implements PreferredSizeWidget {
  const WikAppBar({this.text, super.key});

  final String? text;

  @override
  final Size preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
    );
  }
}
