import 'book.dart';

class CartList {
  final int quantity;
  final Book book;

  CartList({this.quantity, this.book});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'quantity': quantity,
      'book': book
    };
    return map;
  }

}