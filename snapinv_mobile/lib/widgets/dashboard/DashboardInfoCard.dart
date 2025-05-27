import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  final String title;
  final String value;

  const DashboardCard({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return Expanded(
    //   child: Padding(
    //     padding: EdgeInsets.all(2),
    //     child: SizedBox(
    //       height: 90,
    //       child: Card(
    //         elevation: 5,
    //         shape: RoundedRectangleBorder(
    //           borderRadius: BorderRadius.circular(5), // Rounded corners
    //         ),
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             Text(
    //               value,
    //               style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    //             ),
    //             Text(
    //               title,
    //               style: TextStyle(fontSize: 13),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Title with wrapping
                SizedBox(
                  width: constraints.maxWidth,
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                SizedBox(height: 8),

                /// Value
                Text(
                  value,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
