import 'package:flutter/material.dart';

class DetailedCardInfo extends StatelessWidget {
  final IconData icon;
  final String title;

  const DetailedCardInfo({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.blue),
            const SizedBox(height: 8),
            Text(title),
          ],
        ),
      ),
    );
  }
}
