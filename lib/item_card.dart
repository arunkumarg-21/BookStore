import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './book.dart';

class ItemCard extends StatelessWidget {
  final Book book;
  final Function press;


  const ItemCard({
    this.book,
    this.press,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                        image : book.image != null
                        ? AssetImage(book.image)
                        : AssetImage(
                        'assets/book1.jpg'),
                      fit: BoxFit.cover)),
                  ),
                    //child: Image.asset(book.image)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              // products is out demo list
              book.bookName,
              style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          Text(
            "Rs:${book.bookPrice}",
            style: TextStyle(color: Colors.black38),
          )
        ],
      ),
    );
  }
}