import 'package:flutter/material.dart';

class RecentItem extends StatelessWidget {
  final String itemName;
  final int quantity;
  final String timeAgo;
  final bool isIncoming;

  const RecentItem({
    super.key,
    required this.itemName,
    required this.quantity,
    required this.timeAgo,
    required this.isIncoming,
  });

  @override
  Widget build(BuildContext context) {
    final emoji = isIncoming ? '⬇️' : '⬆️';
    final sign = isIncoming ? '+' : '-';
    final color = isIncoming ? Colors.green : Colors.red;
    final unit = quantity == 1 ? 'unit' : 'units';

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: '$emoji $itemName '),
          TextSpan(
            text: '$sign$quantity $unit',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          TextSpan(
            text: ' ($timeAgo)',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}