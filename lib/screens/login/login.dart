import 'package:book_store/bottom_nav/bottom_navigation.dart';
import 'package:book_store/database/db_helper.dart';
import 'package:book_store/screens/home/home.dart';
import 'package:book_store/main.dart';
import 'package:book_store/screens/login/register.dart';
import 'package:book_store/shared_preference/shared_preference.dart';
import 'package:book_store/modals/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  var dbHelper = DBHelper();
  var name;
  var password;
  final sharedPref = MySharedPreference();

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;

    return Scaffold(
        body: SingleChildScrollView(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        SizedBox(
          height: height,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 0,
                child: Container(
                  height: height * .35,
                  width: width,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Welcome To BookStore',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 25)),
                      Container(
                          margin: EdgeInsets.all(16),
                          child: Icon(Icons.book, color: Colors.white, size: 50)),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: height * .25,
                left: 15,
                right: 15,
                child: Container(
                  height: 370,
                  width: width - 40,
                  margin: EdgeInsets.only(left: 20, right: 20, top: 0),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 10,
                            color: Colors.black87,
                            offset: Offset(1, 3))
                      ]),
                  child: Form(
                    key: _formKey,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Sign In",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 20),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10, bottom: 10),
                            child: TextFormField(
                              controller: nameController,
                              validator: (val) =>
                                  val.length == 0 ? 'Enter a name' : null,
                              onSaved: (val) => name = val,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  suffixIcon: Icon(Icons.person),
                                  labelText: 'Name'),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10, bottom: 10),
                            child: TextFormField(
                              controller: passwordController,
                              validator: (val) =>
                                  val.length == 0 ? 'Invalid password' : null,
                              onSaved: (val) => password = val,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                suffixIcon: Icon(Icons.vpn_key),
                                labelText: 'Password',
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: ButtonTheme(
                              minWidth: 150,
                              height: 40,
                              child: RaisedButton(
                                color: Colors.blue,
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    _formKey.currentState.save();
                                    Future<User> user = dbHelper.getUser(name);
                                    user.then((value) {
                                      if (value != null) {
                                        var Name = value.userName;
                                        var Password = value.userPassword;
                                        if (Name == name &&
                                            password == Password) {
                                          sharedPref.saveUser(name, password);
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MyBottomNavigationBar()),
                                              (route) => false);
                                        }
                                      } else {
                                        showAlertDialog(context);
                                      }
                                    });
                                  }
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text(
                                  'Login',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(top: 10),
                            child: Text(
                              "Don't Have a Account?Sign up.",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: ButtonTheme(
                              minWidth: 100,
                              height: 40,
                              child: RaisedButton(
                                color: Colors.blue,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Register()));
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                child: Text(
                                  'Register',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          )
                        ]),
                  ),
                ),
              )
            ],
          ),
        ),
      ]),
    ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    passwordController.dispose();
  }
}

showAlertDialog(BuildContext context) async {
  await showDialog<String>(
    context: context,
    child: AlertDialog(
      contentPadding: const EdgeInsets.all(16.0),
      content: Row(
        children: <Widget>[
          Expanded(child: Text('Invalid Credentials')),
          //Text('Enter valid user name and Password')
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
            onPressed: () {
              Navigator.pop(context);
            })
      ],
    ),
  );
}
