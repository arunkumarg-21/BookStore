import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:book_store/database/db_helper.dart';
import 'package:book_store/screens/orders/orders_screen.dart';
import 'package:book_store/screens/profile/profile_edit.dart';
import 'package:book_store/shared_preference/shared_preference.dart';
import 'package:book_store/modals/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../size_config.dart';
import '../home/home.dart';
import '../login/login.dart';

class UserProfile extends StatefulWidget {
  static String routeName = '/profile';

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  File _image;
  final picker = ImagePicker();
  String base64;

  var dbHelper;
  var check;
  var user = User();
  var user1 = User();

  final sharedPref = MySharedPreference();

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
  }

  Future<User> fetchUser() async {
    await sharedPref.getUser().then((value) {
      check = value;
    });
    await dbHelper.getUser(check).then((value) => user = value);
    return user;
  }

  getImage(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text('Select your choice'),
            children: [
              SimpleDialogOption(
                onPressed: () async {
                  final pickedFile =
                      await picker.getImage(source: ImageSource.gallery);

                  if (pickedFile == null) {
                    return;
                  }
                  File tmpFile = File(pickedFile.path);
                  final Directory dir =
                      await getApplicationDocumentsDirectory();
                  final String path = dir.path;
                  final String fileName =
                      basename(pickedFile.path); // Filename without extension
                  final String fileExtension = extension(pickedFile.path);
                  tmpFile = await tmpFile.copy('$path/$fileName$fileExtension');
                  dbHelper.updateUserImage(user.userId, tmpFile.path);
                  setState(() {});

                  Navigator.pop(context);
                },
                child: Text('Gallery'),
              ),
              SimpleDialogOption(
                onPressed: () async {
                  final pickedFile =
                      await picker.getImage(source: ImageSource.camera);

                  if (pickedFile == null) {
                    return;
                  } else {
                    File tmpFile = File(pickedFile.path);
                    final Directory dir =
                        await getApplicationDocumentsDirectory();
                    final String path = dir.path;
                    final String fileName =
                        basename(pickedFile.path); // Filename without extension
                    final String fileExtension = extension(pickedFile.path);
                    tmpFile =
                        await tmpFile.copy('$path/$fileName$fileExtension');
                    dbHelper.updateUserImage(user.userId, tmpFile.path);
                    setState(() {});

                    Navigator.pop(context);
                  }
                },
                child: Text('Camera'),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double height = size.height;

    return Scaffold(
      backgroundColor: Color(0xFFF5F6F9),
      body: FutureBuilder(
          future: fetchUser(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              user1 = snapshot.data;
              return ListView(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: [
                  Container(
                    child: AppBar(
                      elevation: 3,
                      backgroundColor: Color(0xFFF5F6F9),
                      title: Text(
                        'Profile',
                        style: TextStyle(color: Colors.black),
                      ),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ProfileEdit(user: user1)));
                          },
                          child: Text(
                            'Edit',
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => getImage(context),
                    child: Container(
                      alignment: Alignment.center,
                      height: height * .35,
                      child: Stack(children: [
                        CircleAvatar(
                          radius: 85,
                          backgroundColor: Colors.blueAccent,
                          child: CircleAvatar(
                              radius: 80,
                              backgroundImage: user1.userImage == null
                                  ? AssetImage('assets/images/user.png')
                                  : FileImage(File(user1.userImage))),
                        ),
                        Positioned(
                          bottom: 9,
                          right: 9,
                          child: Container(
                            height: getProportionateScreenWidth(context, 26),
                            width: getProportionateScreenWidth(context, 26),
                            decoration: BoxDecoration(
                              color: Color(0xFFFF4848),
                              shape: BoxShape.circle,
                              border:
                                  Border.all(width: 1.5, color: Colors.white),
                            ),
                            child: Center(
                                child: Icon(
                              Icons.add,
                              color: Colors.white,
                            )),
                          ),
                        )
                      ]),
                      padding: EdgeInsets.all(16),
                    ),
                  ),
                  Container(
                    //height: height / 2,
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Column(children: [
                      TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: user1.userName,
                            hintStyle: TextStyle(color: Colors.black87),
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.deepPurpleAccent,
                            )),
                      ),
                      TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: user1.userEmail,
                            hintStyle: TextStyle(color: Colors.black87),
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.redAccent,
                            )),
                      ),
                      TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: user1.userAddress,
                            hintStyle: TextStyle(color: Colors.black87),
                            prefixIcon: Icon(
                              Icons.home,
                              color: Colors.teal,
                            )),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'change password',
                              hintStyle: TextStyle(color: Colors.blueAccent),
                              prefixIcon: Icon(
                                Icons.vpn_key,
                                color: Colors.green,
                              )),
                        ),
                      ),
                    ]),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    height: 40,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            color: Colors.blue,
                            child: Text(
                              'Your Orders',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OrdersScreen()));
                            },
                          ),
                          RaisedButton(
                            color: Colors.blue,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            child: Text(
                              'Logout',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            onPressed: () {
                              var sharedPref = MySharedPreference();
                              sharedPref.logOut();
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Login()),
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
                    title: Text(
                      'Profile',
                      style: TextStyle(color: Colors.black),
                    )),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: RaisedButton(
                      color: Colors.blueGrey,
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => Login()),
                            (route) => false);
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
