
import 'package:book_store/main.dart';
import 'package:book_store/shared_preference/shared_preference.dart';
import 'package:book_store/modals/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../database/db_helper.dart';
import '../home/home.dart';
import 'login.dart';

class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RegisterState();
  }
}

class RegisterState extends State<Register>{

  final _formKey = GlobalKey<FormState>();


  String name;
  String email;
  String password;
  var dbHelper = DBHelper();

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    return Scaffold(
      body: Stack(
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
                      //height: 430,
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
                        child: SingleChildScrollView(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Register Account",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 20),),
                                Container(
                                  margin: EdgeInsets.only(top: 10,bottom: 10),
                                  child: TextFormField(
                                    controller: nameController,
                                    validator: (val) => val.isEmpty?'Error':null,
                                    onSaved: (val) => name = val,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10)),
                                        suffixIcon: Icon(Icons.person),
                                        labelText: 'Name'),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 10,bottom: 10),
                                  child: TextFormField(
                                    controller: emailController,
                                    validator: (val) => RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$').hasMatch(val) && val.isNotEmpty? null : 'Enter a valid email',
                                    onSaved: (val) => email = val,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10)),
                                        suffixIcon: Icon(Icons.email),
                                        labelText: 'Email'),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 10,bottom: 10),
                                  child: TextFormField(
                                    controller: passwordController,
                                    onSaved: (val) => password = val,
                                    validator: (val) => val.isEmpty?'Error':null,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10)),
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
                                      onPressed: (){
                                        if (_formKey.currentState.validate()) {
                                         _formKey.currentState.save();

                                         User user = User(userName: name,userEmail: email,userPassword: password);
                                          var id = dbHelper.saveUser(user);
                                         if(id != null){
                                           MySharedPreference sharedPref = MySharedPreference();
                                           sharedPref.saveUser(name, password);
                                           Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MyBottomNavigationBar()),(Route<dynamic> route) => false);
                                         }

                                        }
                                      },
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      child: Text('Register',style: TextStyle(color: Colors.white),),

                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(top: 10),
                                  child: Text("Already Have a Account?Sign in.",style: TextStyle(color: Colors.black),),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  child: ButtonTheme(
                                    minWidth: 100,
                                    height: 40,
                                    child: RaisedButton(
                                      color: Colors.blue,
                                      onPressed: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                                      },
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                      child: Text('Login',style: TextStyle(color: Colors.white),),

                                    ),
                                  ),
                                )
                              ]),
                        ),
                      ),
                    ),
                ),
            ],
          ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();

  }

}
