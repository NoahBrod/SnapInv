import 'package:flutter/material.dart';

class RecentActivity extends StatelessWidget {
  final List<String> activities;

  const RecentActivity({Key? key, required this.activities}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Activity',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Divider(thickness: 2, color: Colors.black,),
        ...activities.map(
          (activity) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(fontSize: 16)),
                Expanded(
                  child: Text(
                    activity,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
