import 'package:flutter/material.dart';

class BasicAppButton extends StatelessWidget {

  final VoidCallback onPress;
  final String title;
  final double? height;
  const BasicAppButton({super.key, required this.onPress, required this.title, this.height});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onPress, child: Text(title),style: ElevatedButton.styleFrom(
      minimumSize: Size.fromHeight(height ?? 80)
    ),);
  }
}
