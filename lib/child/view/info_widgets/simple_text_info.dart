import 'package:flutter/material.dart';

class SimpleTextInfo extends StatelessWidget {
  final String text;
  const SimpleTextInfo({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(text),
    );
  }
}
