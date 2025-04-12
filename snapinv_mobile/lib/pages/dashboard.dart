import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:snapinv_mobile/entities/logitem.dart';

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
      List<Logitem> logList =
          jsonList.map((json) => Logitem.fromJson(json)).toList().reversed.toList();

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
      body: Center(
        child: Container(
          color: Color.fromRGBO(235, 235, 235, 1),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20),
                child: SizedBox(
                  // height: 250,
                  child: Card(
                    elevation: 5,
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.album),
                          title: Text('The Enchanted Nightingale'),
                          subtitle: Text(
                              'Music by Julie Gable. Lyrics by Sidney Stein.'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: SizedBox(
                  height: 100.0,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Card(
                        elevation: 5,
                        child: SizedBox(
                          width: 100,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.account_circle,
                                  size: 40,
                                ),
                                Text('Profile 1'),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        Icon(
                                          Icons.fiber_manual_record,
                                          size: 10,
                                          color: Colors.green,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          'Online',
                                          style: TextStyle(color: Colors.green),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
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
                                      style: TextStyle(fontSize: 15, ),
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

              // BOTTOM OF MAIN AREA
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
