import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './book.dart';

class ItemCard extends StatelessWidget {
  final Book book;
  final Function press;
  //final Function cartPress;

  const ItemCard({
    this.book,
    //this.cartPress,
    this.press,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: press,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            // mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Hero(
                    tag: "${book.bookId}",
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          image: DecorationImage(
                              image: book.image != null
                                  ? AssetImage(book.image)
                                  : AssetImage('assets/book1.jpg'),
                              fit: BoxFit.cover)),
                    ),
                    //child: Image.asset(book.image)),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  book.bookName,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
              Text(
                "Rs:${book.bookPrice}",
                style: TextStyle(color: Colors.black38),
              ),
              /*Container(
                height: 25,
                alignment: Alignment.center,
                child: Row(
                  //mainAxisSize: MainAxisSize.min,
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                            *//*SizedBox(
                              height:18,
                              width: 38,
                              child: RaisedButton(
                                color: Colors.redAccent,
                                child: Icon(
                                  Icons.remove,
                                  color: Colors.white,
                                ),
                                onPressed: () {},
                              ),
                            ),
                            Container(margin:EdgeInsets.only(left: 5,right: 5),padding:EdgeInsets.symmetric(vertical: 5),child: Text('10')),
                            SizedBox(
                              height: 18,
                              width: 38,
                              child: RaisedButton(
                                color: Colors.greenAccent,
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                                onPressed: () {},
                              ),
                            ),*//*
                    Container(
                      margin: EdgeInsets.only(left: 8),
                      child: GestureDetector(
                        onTap: cartPress,
                        child:Icon(
                            Icons.add_shopping_cart,
                            color: Colors.deepOrange,
                          ),
                        ),
                      ),
                  ],
                ),
              )*/
            ]));
  }
}