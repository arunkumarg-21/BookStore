import 'package:book_store/database/db_helper.dart';
import 'package:book_store/modals/user.dart';
import 'package:book_store/screens/profile/user_profile.dart';
import 'package:book_store/shared_preference/shared_preference.dart';
import 'package:flutter/material.dart';

class ProfileEdit extends StatefulWidget {
  final User user;

  ProfileEdit({this.user});

  @override
  _ProfileEditState createState() => _ProfileEditState(user);
}

class _ProfileEditState extends State<ProfileEdit> {
  final editKey = GlobalKey<FormState>();

  var name;
  var check;
  var password;
  var email;
  var address;
  var id;
  var user;
  var dbHelper;
  final sharedPref = MySharedPreference();

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var addressController = TextEditingController();

  _ProfileEditState(User user) {
    this.user = user;
  }

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    name = user.userName;
    password = user.userPassword;
    address = user.userAddress;
    email = user.userEmail;
    nameController.text = name;
    passwordController.text = password;
    addressController.text = address;
    emailController.text = email;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double height = size.height;
    return Scaffold(
        backgroundColor: Color(0xFFF5F6F9),
        appBar: AppBar(
          backgroundColor: Color(0xFFF5F6F9),
          title: Text(
            'Edit Profile',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          actions: [
            FlatButton(
              onPressed: () {
                if (editKey.currentState.validate()) {
                  editKey.currentState.save();
                  updateUser();
                  _showDialog(context);
                }
              },
              child: Text(
                'Save',
                style: TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
        body: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: [
              Container(
                //height: height / 2,
                margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Form(
                  key: editKey,
                  child: Column(children: [
                    TextFormField(
                      controller: nameController,
                      validator: (val) =>
                          val.isEmpty ? 'Enter a vaild name' : null,
                      onSaved: (val) => name = val,
                      onChanged: (val) => name = val,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Name',
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.deepPurpleAccent,
                          )),
                    ),
                    TextFormField(
                      controller: emailController,
                      validator: (val) =>
                          RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                                      .hasMatch(val) &&
                                  val.isNotEmpty
                              ? null
                              : 'Enter a valid email',
                      onSaved: (val) => email = val,
                      onChanged: (val) => email = val,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Email',
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.redAccent,
                          )),
                    ),
                    TextFormField(
                      controller: addressController,
                      validator: (val) =>
                          val.isEmpty ? 'Enter a vaild address' : null,
                      onSaved: (val) => address = val,
                      onChanged: (val) => address = val,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Address',
                          prefixIcon: Icon(
                            Icons.home,
                            color: Colors.teal,
                          )),
                    ),
                    TextFormField(
                      obscureText: true,
                      controller: passwordController,
                      validator: (val) =>
                          val.isEmpty ? 'Enter a vaild password' : null,
                      onSaved: (val) {
                        password = val;
                      },
                      onChanged: (val) => password = val,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'password',
                          prefixIcon: Icon(
                            Icons.vpn_key,
                            color: Colors.green,
                          )),
                    ),
                  ]),
                ),
              ),
            ]));
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
                Navigator.popAndPushNamed(context, UserProfile.routeName);
              })
        ],
      ),
    );
  }

  void updateUser() {
    sharedPref.logOut();
    sharedPref.saveUser(name, password);
    User user1 = User(
        userId: user.userId,
        userName: name,
        userEmail: email,
        userAddress: address,
        userPassword: password,
        userImage: user.userImage);
    dbHelper.updateUser(user1);
    //print("updated=====${dbHelper.getUser(user)}");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    addressController.dispose();
  }
}
