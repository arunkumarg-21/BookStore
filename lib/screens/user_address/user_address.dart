import 'package:book_store/database/db_helper.dart';
import 'package:book_store/modals/address_list.dart';
import 'package:book_store/screens/cart/cart_screen.dart';
import 'package:book_store/shared_preference/shared_preference.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserAddress extends StatefulWidget {
  static String routeName = '/user_address';
  @override
  _UserAddressState createState() => _UserAddressState();
}

class _UserAddressState extends State<UserAddress> {
  final formKey = GlobalKey<FormState>();
  var controller = TextEditingController();
  var controller1 = TextEditingController();
  var controller2 = TextEditingController();
  var controller3 = TextEditingController();
  Map<int,bool> itemSelected = Map();
  String address,street,city,state;
  String pinCode,selectedAddress;
  var dbHelper = DBHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Address',style: TextStyle(color: Colors.black),),
        elevation: 3,
      ),
      body: Builder(
        builder:(context)=> Container(
          margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(alignment:Alignment.centerLeft,child: Text('Add New Address',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w400,fontSize: 18),)),
                  TextFormField(
                    controller: controller,
                    decoration: InputDecoration(
                      labelText: 'Enter Street',
                      //border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(0.0)))
                    ),
                    onSaved: (val) => street = val,
                    validator: (val) => val.isEmpty ? "Enter a value":null,

                  ),
                  TextFormField(
                    controller: controller1,
                    decoration: InputDecoration(
                      labelText: 'Enter City',
                      //border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(0.0)))
                    ),
                    onSaved: (val) => city = val,
                    validator: (val) => val.isEmpty ? "Enter a value":null,

                  ),
                  TextFormField(
                    controller: controller2,
                    decoration: InputDecoration(
                      labelText: 'Enter State',
                      //border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(0.0)))
                    ),
                    onSaved: (val) => state = val,
                    validator: (val) => val.isEmpty ? "Enter a value":null,

                  ),
                  TextFormField(
                    controller: controller3,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Enter Pincode',
                      //border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(0.0)))
                    ),
                    onSaved: (val) => pinCode = val,
                    validator: (val) => val.isEmpty ? "Enter a value":null,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: RaisedButton(
                      color: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)
                      ),
                      onPressed: ()async{
                        if(formKey.currentState.validate()) {
                          formKey.currentState.save();
                          address = '$street,$city,$state,$pinCode';
                          var sharePref = MySharedPreference();
                          var name;
                          var id;
                          await sharePref.getUser().then((value) => name=value);
                          var addressList = AddressList(userName: name,deliveryAddress: address,address: address);
                          dbHelper.insertAddress(addressList);
                          Navigator.popAndPushNamed(context, CartScreen.routeName);
                        }
                      },
                      child: Text('Add Address',style: TextStyle(color: Colors.white),),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text('Saved Address',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w400,fontSize: 18)),
                  ),
                  Flexible(
                    child: FutureBuilder<List<String>>(
                        future: getAddressList(),
                        builder: (context,snapshot) {
                          if (snapshot.data != null) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                               // mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:[
                                Padding(
                                  padding:EdgeInsets.all(10),
                                  child: SizedBox(
                                    height:140,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: snapshot.data.length,
                                      itemBuilder: (context, index) {
                                        bool isCurrentIndexSelected = itemSelected[index] == null
                                            ? false
                                            : itemSelected[index];
                                        return GestureDetector(
                                            child: Container(
                                              width: 160,
                                              margin: EdgeInsets.only(right: 10),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(16)),
                                                  border: Border.all(
                                                    color: isCurrentIndexSelected ?Colors.blue:Colors.grey,
                                                    width: 6
                                                  )
                                              ),
                                              child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children:[
                                                Text('Address${(index+1).toString()}',style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.w200),),
                                                Padding(padding:EdgeInsets.only(top: 10),child: Text(snapshot.data[index],style: TextStyle(fontSize: 16,color: Colors.black87,),overflow: TextOverflow.ellipsis,maxLines: 3,),)]),
                                            ),

                                            onTap: (){
                                              selectedAddress = snapshot.data[index];
                                              setState(() {
                                                itemSelected.clear();
                                                itemSelected[index] = !isCurrentIndexSelected;
                                              });
                                            }
                                        );
                                      }
                              ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  child: RaisedButton(
                                    color:Colors.blue,
                                    shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                    onPressed: ()async{
                                      var name;
                                      var sharedPref = MySharedPreference();
                                      await sharedPref.getUser().then((value) => name=value);
                                      dbHelper.updateUserAddress(selectedAddress, name);
                                      Navigator.popAndPushNamed(context, CartScreen.routeName);
                                    },
                                    child: Text('Select',style: TextStyle(color: Colors.white),),
                                  ),
                                )
                            ]);
                          }return Center(
                            child: Text('No Saved Address',style: TextStyle(color: Colors.black),),
                          );
                        }
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
  }

  Future<List<String>> getAddressList() async{
    var sharedPref = MySharedPreference();
     var name;
    await sharedPref.getUser().then((value) => name=value);
    return await dbHelper.getUserAddress(name);
  }

}
