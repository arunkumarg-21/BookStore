import 'package:book_store/modals/book.dart';
import 'package:book_store/screens/details/details_screen.dart';
import 'package:flutter/material.dart';

import 'item_card.dart';

class GenreList extends StatelessWidget {

  final String title;
  final List<Book> books;

  GenreList({@required this.title,@required this.books});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    final double itemHeight = (size.height - kToolbarHeight) / 2;
    final double itemWidth = size.width / 2;
    return Scaffold(
      backgroundColor: Color(0xFFF5F6F9),
      appBar: AppBar(
        backgroundColor: Color(0xFFF5F6F9),
        elevation: 3,
        title: Text(title,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
      ),
      body: Column(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: OrientationBuilder(
                    builder: (context,orientation) {
                      return GridView.count(
                          crossAxisCount:(orientation == Orientation.portrait) ? 2 : 3,
                          childAspectRatio: itemWidth / itemHeight,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                        children: List.generate(books.length, (index) {
                          return ItemCard(
                              book: books[index],
                              press: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DetailsScreen(book: books[index]))));
                        })

                    );
                      }

                  ),
                ),
              )
            ],
          ),
    );
  }
}
