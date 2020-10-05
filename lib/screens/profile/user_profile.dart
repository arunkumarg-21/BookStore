import 'dart:async';

import 'package:book_store/database/db_helper.dart';
import 'package:book_store/screens/orders/orders_screen.dart';
import 'package:book_store/shared_preference/shared_preference.dart';
import 'package:book_store/modals/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../home/home.dart';
import '../login/login.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  var dbHelper;
  var name;
  var check;
  var password;
  var email;
  var address;
  var id;
  var user = User();
  var user1 = User();

  //FocusNode nameFocus;
  FocusNode passwordFocus;
  FocusNode emailFocus;
  FocusNode addressFocus;
  final sharedPref = MySharedPreference();

  //TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //nameFocus = FocusNode();
    passwordFocus = FocusNode();
    emailFocus = FocusNode();
    addressFocus = FocusNode();
    dbHelper = DBHelper();
  }


  Future<User> fetchUser() async {
    await sharedPref.getUser().then((value) {
      check = value;
    });
    await dbHelper.getUser(check).then((value) => user = value);
    return user;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double height = size.height;

    return Scaffold(
      backgroundColor: Color(0xFFF5F6F9),
      /*appBar: AppBar(
        elevation: 3,
        backgroundColor: Color(0xFFF5F6F9),
        title: Text('Profile',style: TextStyle(color: Colors.black),),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              updateUser();
              _showDialog(context);
              FocusScope.of(context).unfocus();
              setState(() {
                fetchUser().then((value) => user1 = value);
              });
            },
            child: Text(
              'Save',
              style: TextStyle(color: Colors.black,fontSize: 18),
            ),
          )
        ],
      ),*/
      body: FutureBuilder(
          future: fetchUser(),
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              user1 = snapshot.data;
              return ListView(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: [
                  Container(
                    child: AppBar(
                      elevation: 3,
                      backgroundColor: Color(0xFFF5F6F9),
                      title: Text('Profile',style: TextStyle(color: Colors.black),),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () {
                            updateUser();
                            _showDialog(context);
                            FocusScope.of(context).unfocus();
                            setState(() {
                              fetchUser().then((value) => user1 = value);
                            });
                          },
                          child: Text(
                            'Save',
                            style: TextStyle(color: Colors.black,fontSize: 18),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: height * .35,
                    child: Container(
                      height: 220,
                      width: 220,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                          color: Color(0xFFF5F6F9),
                          image: DecorationImage(
                            image: AssetImage('assets/images/user.png'),
                            fit: BoxFit.fill,
                          )),
                    ),
                    padding: EdgeInsets.all(16),
                  ),
                  Container(
                    //height: height / 2,
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Column(children: [
                      Row(mainAxisSize: MainAxisSize.min, children: [
                        Expanded(
                          child: TextField(
                            readOnly: true,
                            //controller: nameController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: user1.userName,
                                hintStyle: TextStyle(color: Colors.black87),
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Colors.deepPurpleAccent,
                                )),
                          ),
                        ),
                        /*IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Colors.black87,
                          ),
                          onPressed: () {
                            //nameFocus.requestFocus();
                          },
                        ),*/
                      ]),
                      Row(children: [
                        Expanded(
                          child: TextField(
                            focusNode: emailFocus,
                            controller: emailController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: user1.userEmail,
                                hintStyle: TextStyle(color: Colors.black87),
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Colors.redAccent,
                                )),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Colors.black87,
                          ),
                          onPressed: () {
                            emailFocus.requestFocus();
                          },
                        ),
                      ]),
                      Row(children: [
                        Expanded(
                          child: TextField(
                            focusNode: addressFocus,
                            controller: addressController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: user1.userAddress,
                                hintStyle: TextStyle(color: Colors.black87),
                                prefixIcon: Icon(
                                  Icons.home,
                                  color: Colors.teal,
                                )),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Colors.black87,
                          ),
                          onPressed: () {
                            addressFocus.requestFocus();
                          },
                        ),
                      ]),
                      Row(children: [
                        Expanded(
                          child: TextField(
                            obscureText: true,
                            focusNode: passwordFocus,
                            controller: passwordController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'change password',
                                hintStyle: TextStyle(color: Colors.black87),
                                prefixIcon: Icon(
                                  Icons.vpn_key,
                                  color: Colors.green,
                                )),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Colors.black87,
                          ),
                          onPressed: () {
                            passwordFocus.requestFocus();
                          },
                        ),
                      ]),
                    ]),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:[
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)
                          ),
                        color: Colors.blue,
                        child: Text(
                          'Your Orders',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>
                                  OrdersScreen()));
                        },
                      ),
                        RaisedButton(
                          color: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)
                          ),
                          child: Text(
                            'Logout',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          onPressed: () {
                            var sharedPref = MySharedPreference();
                            sharedPref.logOut();
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) =>
                                    Login()),
                                    (route) => false);
                          },
                        ),
                    ]),
                  ),
                ],
              );
            }
            return Column(
              children: [
                AppBar(
                  elevation: 3,
                  backgroundColor: Color(0xFFF5F6F9),
                  title: Text('Profile',style: TextStyle(color: Colors.black),)
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: RaisedButton(
                      color: Colors.blueGrey,
                      onPressed: (){
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Login()),
                                (route) => false);
                      },
                      child: Text('Login',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                    ),
                  ),
                ),
              ],
            );
          }),

    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //nameFocus.dispose();
    passwordFocus.dispose();
    emailFocus.dispose();
    addressFocus.dispose();
    //nameController.dispose();
    passwordController.dispose();
    emailController.dispose();
    addressController.dispose();
  }

  _showDialog(BuildContext context) async {
    await showDialog<String>(
      context: context,
      child: AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: Row(
          children: <Widget>[
            Expanded(
              child: Text('User Updated.'),
            ),
          ],
        ),
        actions: <Widget>[
          FlatButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      ),
    );
  }

  void updateUser() {
    email = emailController.text == ''? user.userEmail : emailController.text;
    password = passwordController.text == ''? user.userPassword : passwordController.text ;
    address = addressController.text == ''? user.userAddress : addressController.text;
    User user1 = User(
        userId: user.userId,
        userName: user.userName,
        userEmail: email,
        userPassword: password,);
    dbHelper.updateUser(user1);
  }
}
