import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PaymentFailed extends StatelessWidget {
  static String routeName = '/payment_response';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              height: 200,
              margin: EdgeInsets.all(12),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/paymentfailed.png'),
                  fit: BoxFit.fill
                )
              ),
            ),
            Text("Something went Wrong",style: TextStyle(color: Colors.black87,fontSize: 18),),
            Text("Payment Failed",style: TextStyle(color: Colors.black87,fontSize: 18),),
            Container(
              margin: EdgeInsets.only(top: 10),
              alignment: Alignment.center,
              child: ButtonTheme(
                minWidth: 150,
                height: 40,
                child: RaisedButton(
                  color: Colors.blue,
                  onPressed: () => Navigator.pop(context),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    'Go Back',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
