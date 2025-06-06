import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:snapinv_mobile/entities/logitem.dart';

import '../widgets/dashboard/DashboardInfoCard.dart';

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

  @override
  void initState() {
    super.initState();
    getTransactionLog();
  }

  Future<void> getTransactionLog() async {
    final url = Uri.parse('http://192.168.1.140:8080/api/v1/transaction/log');
    // final url = Uri.parse('http://10.0.2.2:8080/api/v1/transaction/log');
    // final url = Uri.parse('https://snapinv.com/api/v1/transaction/log');
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
      // Dashboard
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromRGBO(35, 214, 128, 1),
      ),
      body: SingleChildScrollView(
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.stretch,
                  //   children: [
                  //     const Text('Welcome back!',
                  //         style: TextStyle(
                  //             fontSize: 20, fontWeight: FontWeight.bold)),
                  //     const SizedBox(height: 20),
                  //     GridView.count(
                  //       crossAxisCount: 2,
                  //       shrinkWrap: true,
                  //       physics: const NeverScrollableScrollPhysics(),
                  //       mainAxisSpacing: 10,
                  //       crossAxisSpacing: 10,
                  //       childAspectRatio: 1.5,
                  //       children: const [
                  //         DashboardCard(title: 'Total Items', value: '153'),
                  //         DashboardCard(title: 'Low Stock', value: '12'),
                  //         DashboardCard(title: 'Out of Stock', value: '4'),
                  //         DashboardCard(title: 'Items Added', value: '9'),
                  //       ],
                  //     ),
                  //   ],
                  // ),
                  DashboardCard(title: 'Total Items', value: '153'),
                  DashboardCard(title: 'Low Stock Items', value: '5'),
                  DashboardCard(title: 'Out of Stock', value: '2'),
                  DashboardCard(title: 'Items Added This Week', value: '20'),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: SizedBox(
                height: 350,
                width: 500,
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5), // Rounded corners
                  ),
                  // color: Color.fromRGBO(35, 214, 128, 1),
                  child: transactionLogs.isEmpty
                      ? Center(
                          child: Text(
                            'No log items.',
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      : ListView.separated(
                          itemCount: transactionLogs.length,
                          itemBuilder: (context, index) {
                            final transaction = transactionLogs[index];
                            return SizedBox(
                              height: 50,
                              child: ListTile(
                                isThreeLine: true,
                                title: Text(
                                  "${transaction.logType} ${transaction.logBody}",
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                                subtitle: Text(''),
                                trailing: Text(transaction.date
                                    .toIso8601String()
                                    .split('T')
                                    .first),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Divider(
                              color: Color.fromRGBO(235, 235, 235, 1),
                              height: 0,
                              indent: 10,
                              endIndent: 10,
                              thickness: 2,
                            );
                          },
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
