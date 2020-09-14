import 'package:book_store/db_helper.dart';
import 'package:book_store/shared_preference.dart';
import 'package:book_store/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  FocusNode nameFocus;
  FocusNode passwordFocus;
  FocusNode emailFocus;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameFocus = FocusNode();
    passwordFocus = FocusNode();
    emailFocus = FocusNode();
    dbHelper = DBHelper();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameFocus.dispose();
    passwordFocus.dispose();
    emailFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sharedPref = MySharedPreference();
    sharedPref.getUser().then((value) {
      print('$value======');
      if (value != 'noData') {
        check = value;
      } else {
        check = "notRegistered";
      }
    });
    if (check != "notRegistered") {
      Future<User> user = dbHelper.getUser(check);
      user.then((value) {
        print('${value.userName}=====');
        if (value != null) {
          name = value.userName;
          email = value.userEmail;
          password = value.userPassword;
        }
      });
    } else {
      name = "enter name";
      email = "enter email";
      password = "enter password";
    }

    /*TextEditingController nameController = TextEditingController(text: name);
    TextEditingController emailController =
        TextEditingController(text: password);
    TextEditingController passwordController =
        TextEditingController(text: email);*/

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(20, 24, 20, 20),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            Container(
              height: 300,
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                      decoration: BoxDecoration(color: Colors.grey),
                      child: Column(children: [Text('$name'), Text('$email',style: TextStyle(fontSize: 12),)])),
                  Container(
                    width: 80,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.cyanAccent),
                  )
                ],
              ),
            ),
            Container(
              height: 50,
              margin: EdgeInsets.only(top: 20, left: 20),
              color: Colors.amberAccent,
            ),
          ],
        ),
      ),
    );
  }
}
