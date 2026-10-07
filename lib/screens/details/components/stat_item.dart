import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StatItem extends StatelessWidget {
  const StatItem({
    required this.icon,
    required this.title,
    required this.value,
    this.colors
  });

  final IconData icon;
  final String title;
  final String value;
  final Color? colors;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 22,
          color: colors ??  Colors.grey.shade700,
        ),

        const SizedBox(height: 6),

        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 2),

        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}