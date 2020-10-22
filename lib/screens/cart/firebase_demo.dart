import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FirebaseDemo extends StatefulWidget {
  @override
  _FirebaseDemoState createState() => _FirebaseDemoState();
}

class _FirebaseDemoState extends State<FirebaseDemo> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  List<Message> _messages;

  getToken() {
    _firebaseMessaging.getToken().then((value) => print('token===$value'));
  }

  firebaseListener() {
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
      print('$message');
      setMessage(message);
    },
        onResume: (Map<String, dynamic> message) async {
      print('$message');
      setMessage(message);
    },
        onLaunch: (Map<String, dynamic> message) async {
      print('$message');
      setMessage(message);
    });
  }

  setMessage(Map<String, dynamic> message){
    final notification = message['notification'];
    final data = message['data'];
    final String title = notification['title'];
    final String body = notification['body'];
    final String mMessage = data['message'];
    setState(() {
      Message m = Message(title: title,body: body,message: mMessage);
      _messages.add(m);
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _messages = List<Message>();
    getToken();
    firebaseListener();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase'),
      ),
      body: ListView.builder(
        itemCount: _messages.length == null ? 0:_messages.length,
        itemBuilder: (context,index) {
          if (_messages.length != null) {
            return Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(_messages[index].message,
                  style: TextStyle(color: Colors.black, fontSize: 16),),
              ),
            );
          }return Center(child:Text('noDate'));
        }
      )
    );
  }
}

class Message{
  String title;
  String body;
  String message;
  Message({this.title,this.body,this.message});
}
