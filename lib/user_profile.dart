import 'package:book_store/db_helper.dart';
import 'package:book_store/shared_preference.dart';
import 'package:book_store/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home.dart';
import 'login.dart';

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

  //FocusNode nameFocus;
  FocusNode passwordFocus;
  FocusNode emailFocus;
  FocusNode addressFocus;

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
    final sharedPref = MySharedPreference();
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
      appBar: AppBar(
        title: Text('Profile'),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              updateUser();
              _showDialog(context);

            },
            child: Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
          future: fetchUser(),
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              User user = snapshot.data;
              return ListView(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: height * .35,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          image: DecorationImage(
                            image: AssetImage('assets/user.jpg'),
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
                                labelText: user.userName,
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
                                labelText: user.userEmail,
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
                                labelText: user.userAddress,
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
                                labelText: 'change password',
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
                    alignment: Alignment.bottomCenter,
                    color: Colors.white,
                    child: RaisedButton(
                      color: Colors.blue,
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
                  )
                ],
              );
            }
            return Container(
              alignment: Alignment.center,
              child: RaisedButton(
                onPressed: (){
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Login()),
                          (route) => false);
                },
                child: Text('Login',style: TextStyle(fontWeight: FontWeight.bold),),
              ),
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
    email = emailController.text == null? user.userEmail : emailController.text;
    password = passwordController.text == null? user.userPassword : passwordController.text ;
    address = addressController.text == null? user.userAddress : addressController.text;
    User user1 = User(
        userId: user.userId,
        userName: user.userName,
        userEmail: email,
        userPassword: password,
        userAddress: address);
    dbHelper.updateUser(user1);
  }
}
