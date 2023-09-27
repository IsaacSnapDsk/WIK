import 'package:flutter/material.dart';

class WikButton extends StatelessWidget {
  const WikButton({
    required this.onPressed,
    required this.text,
    this.color,
    super.key,
  });

  final Function()? onPressed;
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(
          color ?? Theme.of(context).colorScheme.primary,
        ),
        shape: const MaterialStatePropertyAll(
          ContinuousRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(
                8,
              ),
            ),
          ),
        ),
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
