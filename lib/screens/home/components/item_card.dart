import 'package:book_store/constants.dart';
import 'package:book_store/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../modals/book.dart';

class ItemCard extends StatelessWidget {
  final Book book;
  final Function press;
  final double width, aspectRatio;

  const ItemCard(
      {this.book, this.press, this.width = 140, this.aspectRatio = 1.02});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: getProportionateScreenWidth(context, 20)),
      child: SizedBox(
        width: getProportionateScreenWidth(context, width),
        child: GestureDetector(
          onTap: press,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: AspectRatio(
                    aspectRatio: aspectRatio,
                    child: Container(
                      padding: EdgeInsets.all(
                          getProportionateScreenWidth(context, 20)),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                              book.image != null
                                  ? book.image
                                  : 'assets/images/book1.jpg',
                            ),
                            fit: BoxFit.cover),
                        color: kSecondaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                book.bookName,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              Text(
                "Rs:${book.bookPrice}",
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: getProportionateScreenWidth(context, 16),
                    fontWeight: FontWeight.w400),
              )
            ],
          ),
        ),
      ),
    );
  }
}
