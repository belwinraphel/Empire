import 'package:flutter/material.dart';

Widget filterTile(
    String text, IconData? icon, bool isSelected, BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width * 20,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey[300]!),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 4),
        ],
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 4),
        Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.grey[600]),
      ],
    ),
  );
}
