import 'package:book_store/database/db_helper.dart';
import 'package:book_store/modals/book.dart';
import 'package:book_store/screens/details/details_screen.dart';
import 'package:book_store/screens/home/components/item_card.dart';
import 'package:book_store/screens/home/components/section_title.dart';
import 'package:book_store/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'genre_card.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(context,20)),
            child: SectionTitle(
              title: 'Popular Genre',
            ),
          ),
          SizedBox(
            height: getProportionateScreenWidth(context,20),
          ),
          Padding(
            padding: EdgeInsets.only(
                right: getProportionateScreenWidth(context,20)),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                GenreCard(
                  category: "Thriller",
                  numOfBooks: "10+",
                  press: () {},
                  image: "assets/images/thriller.jpg",
                ),
                GenreCard(
                  category: "Novel",
                  numOfBooks: "10+",
                  press: () {},
                  image: "assets/images/novel.jpg",
                ),
                GenreCard(
                  category: "Romance",
                  numOfBooks: "10+",
                  press: () {},
                  image: "assets/images/romance.jpg",
                ),
                GenreCard(
                  category: "Fiction",
                  numOfBooks: "10+",
                  press: () {},
                  image: "assets/images/fiction.jpg",
                ),
              ]),
            ),
          )
        ],
      ),
      SizedBox(
        height: getProportionateScreenWidth(context,30),
      ),
      Column(children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(context,20)),
          child: SectionTitle(
            title: 'Trending',
          ),
        ),
        SizedBox(
          height: getProportionateScreenWidth(context,20),
        ),
        SizedBox(
            height: 200,
            child: FutureBuilder(
                future: fetchBooks(),
                builder: (context,snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          Book book = snapshot.data[index];
                          return ItemCard(
                            book: book,
                            press: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DetailsScreen(book: book)));
                            },
                          );
                        });
                  }return CircularProgressIndicator();
                }
            )
        )
      ]),
      SizedBox(
        height: getProportionateScreenWidth(context,30),
      ),
      Column(children: [
        Padding(
          padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(context,20)),
          child: SectionTitle(
            title: 'Available Books',
          ),
        ),
        SizedBox(
          height: getProportionateScreenWidth(context,20),
        ),
        SizedBox(
          height: 200,
          child: FutureBuilder(
            future: fetchBooks(),
            builder: (context,snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      Book book = snapshot.data[index];
                      return ItemCard(
                        book: book,
                        press: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DetailsScreen(book: book)));
                        },
                      );
                    });
              }return CircularProgressIndicator();
            }
          )
        )
      ]),
    ]);
  }

  Future<List<Book>> fetchBooks() {
    var dbHelper = DBHelper();
    final books = dbHelper.getBooks();
    return books;
  }

}
