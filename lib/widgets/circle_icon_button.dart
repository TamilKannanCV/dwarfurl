import 'package:flutter/material.dart';

class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
  }) : super(key: key);

  final Icon icon;
  final VoidCallback onPressed;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.4),
        borderRadius: BorderRadius.circular(50.0),
        border: Border.all(),
      ),
      child: IconButton(
        tooltip: tooltip,
        icon: icon,
        onPressed: onPressed,
      ),
    );
  }
}
