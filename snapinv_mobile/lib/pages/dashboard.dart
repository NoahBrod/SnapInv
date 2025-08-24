import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:snapinv_mobile/constants/api_config.dart';
import 'package:snapinv_mobile/entities/logitem.dart';
import 'package:snapinv_mobile/widgets/dashboard/DashboardButton.dart';
import 'package:snapinv_mobile/widgets/dashboard/DashboardChart.dart';

import '../widgets/dashboard/DashboardInfoCard.dart';
import '../widgets/dashboard/RecentActivity.dart';

class DashboardPage extends StatefulWidget {
  static final GlobalKey<DashboardPageState> pageKey =
      GlobalKey<DashboardPageState>();

  DashboardPage() : super(key: pageKey);

  @override
  State<DashboardPage> createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage>
    with AutomaticKeepAliveClientMixin {
  List<Logitem> transactionLogs = [];
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    getTransactionLog();
  }

  Future<void> getTransactionLog() async {
    final url = Uri.parse('${ApiConfig.baseUrl}/api/v1/transaction/log');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        print('Retrieved Log');
      } else {
        print('Error: ${response.statusCode}');
      }

      List<dynamic> jsonList = jsonDecode(response.body);
      List<Logitem> logList = jsonList
          .map((json) => Logitem.fromJson(json))
          .toList()
          .reversed
          .toList();

      setState(() {
        transactionLogs = logList;
      });
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Row(
                  children: [
                    Text(
                      'SnapInv',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                        onPressed: () => {},
                        icon: Icon(
                          Icons.account_circle,
                          size: 40,
                          color: Colors.black,
                        ))
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Row(
                  children: [
                    Text(
                      'Welcome back PERSON_NAME!',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Expanded(
                    // child:
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        DashboardCard(title: 'Total Items', value: '153'),
                        SizedBox(height: 10),
                        DashboardCard(title: 'Low Stock', value: '12'),
                        SizedBox(height: 10),
                        DashboardCard(title: 'Out of Stock', value: '4'),
                      ],
                    ),
                    // ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        children: [
                          const Text(
                            'Recent Activity',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const RecentActivity(
                            activities: [
                              'Item A was restocked',
                              'User John added new inventory',
                              'Low stock alert for Item B',
                              'Item C was deleted',
                              'Backup completed',
                              'Settings updated by Admin',
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'Inventory Overview',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.only(left: 40, right: 40, top: 10),
                child: DashboardChart(),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.3,
                  children: [
                    DashboardButton(
                        label: 'Add Item', icon: Icons.add, onPressed: () {}),
                    DashboardButton(
                        label: 'Edit Item', icon: Icons.edit, onPressed: () {}),
                    DashboardButton(
                        label: 'Scan Barcode',
                        icon: Icons.qr_code,
                        onPressed: () {}),
                    DashboardButton(
                        label: 'Inventory List',
                        icon: Icons.shelves,
                        onPressed: () {}),
                    DashboardButton(
                        label: 'Reports',
                        icon: Icons.bar_chart,
                        onPressed: () {}),
                    DashboardButton(
                        label: 'Settings',
                        icon: Icons.settings,
                        onPressed: () {}),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
