import 'package:book_store/database/db_helper.dart';
import 'package:book_store/modals/user.dart';
import 'package:book_store/screens/login/reset_password.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
   TextEditingController _controller = TextEditingController();
   final  _dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    var _userName;
    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Password",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
        elevation: 3,
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            alignment: Alignment.centerLeft,
            child: Text("Enter the User Id used for Registration",style: TextStyle(color: Colors.black87,fontSize: 18),),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10,0,10,10),
            child: TextField(
              controller: _controller,
              onChanged: (val) => _userName = val,
              onSubmitted: (val) => _userName =val,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                hintText: "Enter your user Id"
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
                onPressed: () async{
                  if(_userName != null || _userName != ""){
                    User user;
                    await _dbHelper.getUser(_userName).then((value) {
                      user = value;
                      if(user != null){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPassword(user: user)));
                      }else{
                        showAlertDialog(context);
                      }
                    });
                  }
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  'Reset Password',
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
             Expanded(child: Text('Account Not Found')),
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
