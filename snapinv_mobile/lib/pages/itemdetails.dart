import 'package:flutter/material.dart';
import '../entities/inventoryitem.dart';

class ItemDetailsPage extends StatefulWidget {
  final InventoryItem item;
  const ItemDetailsPage({required this.item});

  @override
  State<ItemDetailsPage> createState() => _ItemDetailsPageState(item: item);
}

class _ItemDetailsPageState extends State<ItemDetailsPage> {
  bool editing = false;

  final InventoryItem item;

  _ItemDetailsPageState({required this.item});

  @override
  Widget build(BuildContext context) {
    // final TextEditingController _nameController =
    //     TextEditingController(text: '${item.name}');
    // final TextEditingController _descriptionController =
    //     TextEditingController(text: '${item.description}');
    // final TextEditingController _quantityController =
    //     TextEditingController(text: '${item.quantity}');
    // final TextEditingController _acqPriceController =
    //     TextEditingController(text: '${item.acqPrice}');
    //     final TextEditingController _salePriceController =
    //     TextEditingController(text: '${item.salePrice}');

    bool editing = false;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          item.name,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromRGBO(35, 214, 128, 1),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          TextButton(
            onPressed: () {

            },
            child: Text('Edit'),
          ),
        ],
      ),
      floatingActionButton: (item.code == null)
          ? null
          : FloatingActionButton(
              onPressed: () {
                setState(() {
                  item.code = 'code';
                });
              },
              backgroundColor: Color.fromRGBO(35, 214, 128, 1),
              elevation: 5,
              child: Icon(
                Icons.qr_code_scanner,
                color: Colors.white,
              ),
            ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: item.image == null
                    ? Container(
                        width: 300,
                        height: 300,
                        color: Colors.grey,
                      )
                    : Image.file(
                        item.image!,
                        width: 300,
                        height: 300,
                        fit: BoxFit.cover,
                      ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 5),
                          child: Text(
                            'Code',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            // border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: Color.fromRGBO(225, 225, 225, 1),
                          ),
                          // height: 50,
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            item.code != null ? item.code! : "",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 5),
                          child: Text(
                            'Description',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            // border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: Color.fromRGBO(225, 225, 225, 1),
                          ),
                          height: 80,
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            item.description != null ? item.description! : "",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 5),
                          child: Text(
                            'Quantity',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        ConstrainedBox(
                          constraints:
                              BoxConstraints(minWidth: 60),
                          child: IntrinsicWidth(
                            child: Container(
                              padding: EdgeInsets.all(5),
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                // border: Border.all(color: Colors.black),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                    color: Color.fromRGBO(225, 225, 225, 1),
                              ),
                              // height: 40,
                              width: 60,
                              alignment: Alignment.center,
                              child: Text(
                                item.quantity.toString(),
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(left: 5),
                          child: Text(
                            'Price',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            // border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: Color.fromRGBO(225, 225, 225, 1),
                          ),
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            item.price.toString(),
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
