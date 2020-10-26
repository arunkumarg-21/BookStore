import 'package:book_store/database/db_helper.dart';
import 'package:book_store/modals/user.dart';
import 'package:book_store/screens/login/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ResetPassword extends StatelessWidget {
  final User user;
  final dbHelper  =DBHelper();
  ResetPassword({this.user});
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var newPassword;
    var confirmPassword;
    return Scaffold(
      appBar: AppBar(
        title: Text("Change Password",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
        elevation: 3,
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            alignment: Alignment.centerLeft,
            child: Text("Enter a Password to change",style: TextStyle(color: Colors.black87,fontSize: 18),),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: TextField(
              controller: _newPassword,
              onChanged: (val) => newPassword = val,
              onSubmitted: (val) => newPassword =val,
              obscureText: true,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  hintText: "New Password"
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: TextField(
              controller: _confirmPassword,
              onChanged: (val) => confirmPassword = val,
              onSubmitted: (val) => confirmPassword =val,
              obscureText: true,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  hintText: "Confirm Password"
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
                  if(newPassword == confirmPassword){
                    User user1 = User(userName: user.userName,userPassword: confirmPassword,userImage: user.userImage,userId: user.userId,userEmail: user.userEmail,userAddress: user.userAddress);
                    dbHelper.updateUser(user1);
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  }else{
                    showAlertDialog(context);
                  }
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  'Save Password',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  showAlertDialog(BuildContext context) async {
    await showDialog<String>(
      context: context,
      child: AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: Row(
          children: <Widget>[
            Expanded(child: Text('Passwords Do Not Match')),
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
}
