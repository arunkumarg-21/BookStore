import 'package:book_store/database/db_helper.dart';
import 'package:book_store/screens/orders/orders_screen.dart';
import 'package:book_store/shared_preference/shared_preference.dart';
import 'package:book_store/modals/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DeliveryAddress extends StatefulWidget {
  @override
  _DeliveryAddressState createState() => _DeliveryAddressState();
}

class _DeliveryAddressState extends State<DeliveryAddress> {
  TextEditingController addressController = TextEditingController();
  var dbHelper = DBHelper();
  var selectedAddress;
  var addresses = List<String>();
  Map<int, bool> isSelected = Map();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Address'),
      ),
      body: Builder(
        builder: (context) => Container(
          margin: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 50,
                child: Text(
                  'Select Your Address to Deliver',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              FutureBuilder<List<String>>(
                future: fetchUserAddress(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot?.data?.length ?? 0,
                        itemBuilder: (context, index) {
                          addresses = snapshot.data;
                          bool isCurrentItemSelected = isSelected[index] == null
                              ? false
                              : isSelected[index];
                          return GestureDetector(
                            onTap: () {
                              selectedAddress = snapshot.data[index];
                              setState(() {
                                snapshot.data.clear();
                                isSelected.clear();
                                isSelected[index] = !isCurrentItemSelected;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.all(10),
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius:BorderRadius.circular(10),
                                  border: Border.all(
                                      color: isCurrentItemSelected
                                          ? Colors.blue
                                          : Colors.grey,
                                      width: 5)),
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  addresses[index] != null
                                      ? snapshot.data[index]
                                      : '',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 4,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                  return Center(
                    child: Text('nodata'),
                  );
                },
              ),
              Container(
                height: 50,
                alignment: AlignmentDirectional.bottomCenter,
                child: RaisedButton(
                  color: Colors.blue,
                  onPressed: () {
                    _showOrderDialog(context);
                  },
                  child: Text('Select',style:TextStyle(color: Colors.white)),
                ),
              ),
              Container(
                height: 50,
                alignment: AlignmentDirectional.bottomCenter,
                child: RaisedButton(
                  color: Colors.blue,
                  onPressed: () {
                    _showDialog(context);
                  },
                  child: Text('Add New Address',style: TextStyle(color: Colors.white),),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _showDialog(BuildContext context) async {
    await showDialog<String>(
      context: context,
      child: AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            Expanded(
              child: new TextField(
                autofocus: true,
                controller: addressController,
                decoration: new InputDecoration(labelText: 'Enter Address'),
              ),
            )
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              }),
          new FlatButton(
              child: const Text('OK'),
              onPressed: () async {
                var name;
                var address = addressController.text;
                var user = User();
                var sharedPref = MySharedPreference();
                await sharedPref.getUser().then((value) => name = value);
                await dbHelper.getUser(name).then((value) => user = value);
                User user1 = User(
                    userId: user.userId,
                    userName: user.userName,
                    userEmail: user.userEmail,
                    userPassword: user.userPassword,
                    userAddress: user.userAddress,
                    userAddress1: address);
                await dbHelper.updateUser(user1);
                Navigator.pop(context);
                setState(() {
                  addresses.clear();
                });
                //await fetchUserAddress().then((value) => addresses = value);
              })
        ],
      ),
    );
  }

  Future<List<String>> fetchUserAddress() async {
    var name;
    var addres = List<String>();
    var sharedPref = MySharedPreference();
    await sharedPref.getUser().then((value) => name = value);
    await dbHelper.getUserAddress(name).then((value) {
      value.forEach((element) {
        addres.add(element);
      });
    });
    return addres;
  }

  onTapped(String data) {}

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    addressController.dispose();
  }

  void _showOrderDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: Text('Are you sure?'),
        content: Text('Do you want to place order'),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('No'),
          ),
          FlatButton(
            onPressed: () async{
              var name;
              var sharedPref = MySharedPreference();
              await sharedPref.getUser().then((value) => name = value);
              dbHelper.deleteUserCart(name);
              Future.delayed(
                  Duration(seconds: 1),
                      () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OrdersPage())));
             // Navigator.of(context).pop();
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }
}
