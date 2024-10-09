import 'package:flutter/material.dart';

class _Inventory extends StatefulWidget {
  const _Inventory({super.key});

  @override
  State<_Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<_Inventory>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      // Dashboard
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20),
              child: SizedBox(
                height: 250,
                child: Card(
                  elevation: 5,
                  child: Column(
                    children: <Widget>[
                      const ListTile(
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
                                        'Profile 1',
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
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
