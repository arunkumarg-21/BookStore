import 'dart:async';
import 'dart:io' as io;
import 'package:book_store/modals/cartlist.dart';
import 'package:book_store/modals/user.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../modals/book.dart';

class DBHelper {
  static Database _db;
  static const String ID = 'id';
  static const String NAME = 'name';
  static const String DESCRIPTION = 'description';
  static const String PRICE = 'price';
  static const String EMAIL = 'email';
  static const String PASSWORD = 'password';
  static const String RATING = 'rating';
  static const String IMAGE = 'image';
  static const String QUANTITY = 'quantity';
  static const String BOOK_TABLE = 'Books';
  static const String USER_TABLE = 'Users';
  static const String USER_ADDRESS = 'Address';
  static const String USER_ADDRESS1 = 'Address1';
  static const String CART_TABLE = 'Cart';
  static const String ORDER_TABLE = 'OrderTable';
  static const String ORDER_ID = 'OrderId';
  static const String CART_ID = 'CartId';
  static const String BOOK_ID = 'BookId';
  static const String USER_NAME = 'UserName';
  static const String DB_NAME = 'books1.db';

  Future<Database> get db async{
    if(_db != null){
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async{
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path,DB_NAME);
    var db = await openDatabase(path, version: 1,onCreate: _onCreate);
    return db;

  }

  _onCreate(Database db,int version) async {
    await db.execute("CREATE TABLE $BOOK_TABLE($ID INTEGER PRIMARY KEY,$NAME TEXT,$DESCRIPTION TEXT,$PRICE INTEGER,$RATING REAL,$IMAGE TEXT)");
    await db.execute("CREATE TABLE $CART_TABLE($CART_ID INTEGER PRIMARY KEY,$BOOK_ID INTEGER,$USER_NAME TEXT,$QUANTITY INTEGER)");
    await db.execute("CREATE TABLE $ORDER_TABLE($ORDER_ID INTEGER PRIMARY KEY,$BOOK_ID INTEGER,$USER_NAME TEXT,$QUANTITY INTEGER)");
    await db.execute("CREATE TABLE $USER_TABLE($ID INTEGER PRIMARY KEY,$NAME TEXT,$EMAIL TEXT,$PASSWORD TEXT,$USER_ADDRESS TEXT,$USER_ADDRESS1 TEXT)");
  }

   Future<Book> saveBook(Book book) async {
    var dbClient = await db;
    int id = await dbClient.insert(BOOK_TABLE, book.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
    return book;
  }

  Future<int> saveUser(User user) async {
    var dbClient = await db;
    int id = await dbClient.insert(USER_TABLE, user.userToMap(),conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  Future<int> insertCart(int id,String name,int quantity) async{
    var dbClient = await db;
    int i;
    List<Map> map = await dbClient.query(CART_TABLE,where: "$BOOK_ID = ? and $USER_NAME = ?",whereArgs: [id,name]);
    print(map);
    if(map.isEmpty) {
       i = await dbClient.rawInsert(
          "INSERT INTO $CART_TABLE($BOOK_ID,$USER_NAME,$QUANTITY) VALUES(?,?,?)",
          [id, name,quantity]);
    }
    return i;
  }

  Future<List<String>> getUserAddress(String name) async{
    var dbClient = await db;
    var address = List<String>();
    List<Map> map = await dbClient.query(USER_TABLE,where: "$NAME = ?",whereArgs: [name]);
    if(map.isEmpty){
      return null;
    }
    map.forEach((element) {
      address.add(element[USER_ADDRESS]);
      address.add(element[USER_ADDRESS1]);
    });
    print('address===${address[1]}');
    return address;
  }

  insertOrder(int id,String name,int quantity) async{
    var dbClient = await db;
      List<Map> map = await dbClient.query(ORDER_TABLE,where: "$BOOK_ID = ? and $USER_NAME = ?",whereArgs: [id,name]);
      if(map.isEmpty) {
        await dbClient.rawInsert(
            'INSERT INTO $ORDER_TABLE($BOOK_ID,$USER_NAME,$QUANTITY) VALUES(?,?,?)',
            [id, name,quantity]);
      }
  }


  insertOrders(List<int> id,String name,List<int> quantity) async{
    var dbClient = await db;
    for(int i=0;i<id.length;i++){
      var curId = id[i];
      var curQuantity = quantity[i];
      List<Map> map = await dbClient.query(ORDER_TABLE,where: "$BOOK_ID = ? and $USER_NAME = ?",whereArgs: [curId,name]);
      if(map.isEmpty) {
        await dbClient.rawInsert(
            'INSERT INTO $ORDER_TABLE($BOOK_ID,$USER_NAME,$QUANTITY) VALUES(?,?,?)',
            [curId, name,curQuantity]);
      }
    }
  }

   deleteCart(int id,String name) async{
    var dbClient = await db;
    await dbClient.delete(CART_TABLE,where: "$BOOK_ID = ? and $USER_NAME = ?",whereArgs: [id,name]);
  }

  deleteUserCart(String name) async{
    var dbClient = await db;
    await dbClient.delete(CART_TABLE,where: " $USER_NAME = ?",whereArgs: [name]);
  }

  deleteCart1(int id) async{
    var dbClient = await db;
    await dbClient.delete(CART_TABLE,where: "$BOOK_ID = ?",whereArgs: [id]);
  }

  Future<User> getUser(String name) async{
    var dbClient = await db;
    List<Map> map = await dbClient.query(USER_TABLE,where: "name = ?" ,whereArgs: [name]);
    User user;
      map.forEach((element) {
        user = User(
            userId: element['id'], userName: element['name'], userPassword: element['password'],userEmail: element['email'],userAddress: element[USER_ADDRESS]);
      });
    return user;
  }

  Future<int> updateUser(User user) async{
    var dbClient  = await db;
    int id = await dbClient.update(USER_TABLE, user.userToMap(),where: 'id = ?',whereArgs: [user.userId]);
    return id;
  }

  Future<String> getQuantity(int bookId,String name) async{
    var dbClient = await db;
    List<Map> map = await dbClient.rawQuery("SELECT $QUANTITY FROM $CART_TABLE WHERE $BOOK_ID = ? AND $USER_NAME = ?",[bookId,name]);
    map.forEach((element) {
      print('quantity====${element[QUANTITY]}');
      return element[QUANTITY].toString();
    });
  }

  Future<int> getTotal(String name) async{
    var dbClient = await db;
    int total=0;
    List<Map> map = await dbClient.rawQuery("SELECT $BOOK_TABLE.$PRICE,$CART_TABLE.$QUANTITY FROM $BOOK_TABLE LEFT JOIN $CART_TABLE ON $BOOK_TABLE.$ID = $CART_TABLE.$BOOK_ID WHERE $USER_NAME = ?",[name]);
    map.forEach((element) {
      total = total + element[PRICE]*element[QUANTITY];
    });
    return total;
  }

  Future<List<CartList>> getCart(String name) async{
    var dbClient = await db;
    List<Map> maps = await dbClient.rawQuery("SELECT $BOOK_TABLE.*,$CART_TABLE.$QUANTITY FROM $BOOK_TABLE LEFT JOIN $CART_TABLE ON $BOOK_TABLE.$ID = $CART_TABLE.$BOOK_ID WHERE $USER_NAME = ?",[name]);
    if(maps.length > 0){
      return List.generate(maps.length, (index) =>
          CartList(
            quantity: maps[index]['$QUANTITY'],
              book: Book(
              bookId: maps[index]['id'],
              bookName: maps[index]['name'],
              bookDescription: maps[index]['description'],
              bookPrice: maps[index]['price'],
              rating: maps[index]['rating'],
              image: maps[index]['image']
              )
          ));
    }else{
      return null;
    }
  }

  Future<List<CartList>> getOrder(String name) async{
    var dbClient = await db;
    List<Map> maps = await dbClient.rawQuery("SELECT $BOOK_TABLE.*,$ORDER_TABLE.$QUANTITY FROM $BOOK_TABLE LEFT JOIN $ORDER_TABLE ON $BOOK_TABLE.$ID = $ORDER_TABLE.$BOOK_ID WHERE $USER_NAME = ?",[name]);
    if(maps.length > 0){
      return List.generate(maps.length, (index) =>
          CartList(
              quantity: maps[index]['$QUANTITY'],
              book: Book(
                  bookId: maps[index]['id'],
                  bookName: maps[index]['name'],
                  bookDescription: maps[index]['description'],
                  bookPrice: maps[index]['price'],
                  rating: maps[index]['rating'],
                  image: maps[index]['image']
              )
          ));
    }else{
      return null;
    }
  }


  Future<List<Book>> getBooks() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(BOOK_TABLE);
    if(maps.length > 0){
      /*for(int i=0; i < maps.length;i++){
        books.add(Book.fromMap(maps[i]));*/
      return List.generate(maps.length, (index) {
      return Book(
          bookId: maps[index]['id'],
         bookName: maps[index]['name'],
        bookDescription: maps[index]['description'],
        bookPrice: maps[index]['price'],
        rating: maps[index]['rating'],
          image: maps[index]['image']
      );
      }

      );
      }else{
      return null;
    }
    }



  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }

}
