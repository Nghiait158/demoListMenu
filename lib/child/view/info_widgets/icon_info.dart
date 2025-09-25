import 'package:flutter/material.dart';

class IconInfo extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color color;

  const IconInfo({
    super.key,
    required this.icon,
    this.size = 50,
    this.color = Colors.amber,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(
        icon,
        size: size,
        color: color,
      ),
    );
  }
}
