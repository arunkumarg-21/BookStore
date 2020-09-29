import 'package:flutter/material.dart';

class Book{
  final int bookId;
  final String bookName;
  final String bookDescription;
  final int bookPrice;
  final double rating;
  final String image;

  Book({this.bookId,this.bookName,this.bookDescription,this.bookPrice,this.rating,this.image});

  Map<String,dynamic> toMap(){
    var map = <String,dynamic>{
      'id' : bookId,
      'name' : bookName,
      'description' : bookDescription,
      'price' : bookPrice,
      'rating' : rating,
      'image' : image
    };
    return map;
  }

}