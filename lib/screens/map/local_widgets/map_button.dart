import 'package:flutter/material.dart';

// inspire style by google map button
class MapButton extends StatelessWidget {
  const MapButton({
    Key? key,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  final IconData icon;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 1,
            spreadRadius: 0,
            offset: Offset(0, 0.1),
          )
        ],
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Icon(icon, color: Colors.black.withOpacity(0.6), size: 16),
        style: TextButton.styleFrom(
          backgroundColor: Colors.white.withOpacity(0.8),
          primary: Colors.grey.withOpacity(0.2),
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
