import 'dart:async';
import 'dart:io' as io;
import 'package:book_store/user.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import './book.dart';

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
  static const String BOOK_TABLE = 'Books';
  static const String USER_TABLE = 'Users';
  static const String USER_ADDRESS = 'Address';
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
    await db.execute("CREATE TABLE $BOOK_TABLE($ID INTEGER PRIMARY KEY,$NAME TEXT,$DESCRIPTION TEXT,$PRICE INTEGER,$RATING INTEGER,$IMAGE TEXT)");
    await db.execute("CREATE TABLE $CART_TABLE($CART_ID INTEGER PRIMARY KEY,$BOOK_ID INTEGER,$USER_NAME TEXT)");
    await db.execute("CREATE TABLE $ORDER_TABLE($ORDER_ID INTEGER PRIMARY KEY,$BOOK_ID INTEGER,$USER_NAME TEXT)");
    await db.execute("CREATE TABLE $USER_TABLE($ID INTEGER PRIMARY KEY,$NAME TEXT,$EMAIL TEXT,$PASSWORD TEXT,$USER_ADDRESS TEXT)");
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

  Future<int> insertCart(int id,String name) async{
    var dbClient = await db;
    int i;
    List<Map> map = await dbClient.query(CART_TABLE,where: "$BOOK_ID = ?",whereArgs: [id]);
    if(map.isEmpty) {
       i = await dbClient.rawInsert(
          "INSERT INTO $CART_TABLE($BOOK_ID,$USER_NAME) VALUES(?,?)",
          [id, name]);
    }
    return i;
  }

  insertOrder(List<int> id,String name) async{
    var dbClient = await db;
    for(int i=0;i<id.length;i++){
      var curId = id[i];
      List<Map> map = await dbClient.query(ORDER_TABLE,where: "$BOOK_ID = ?",whereArgs: [curId]);
      if(map.isEmpty) {
        await dbClient.rawInsert(
            'INSERT INTO $ORDER_TABLE($BOOK_ID,$USER_NAME) VALUES(?,?)',
            [curId, name]);
      }
    }
  }

   deleteCart(int id) async{
    var dbClient = await db;
    await dbClient.delete(CART_TABLE,where: "$BOOK_ID = ?",whereArgs: [id]);
  }

  Future<User> getUser(String name) async{
    var dbClient = await db;
    List<Map> map = await dbClient.query(USER_TABLE,where: "name = ?" ,whereArgs: [name]);
    User user;
      map.forEach((element) {
        user = User(
            userId: element['id'], userName: element['name'], userPassword: element['password'],userEmail: element['email']);
      });
    return user;
  }

  Future<List<Book>> getCart(String name) async{
    print('cart===');
    var dbClient = await db;
    List<Map> maps = await dbClient.rawQuery("SELECT $BOOK_TABLE.* FROM $BOOK_TABLE LEFT JOIN $CART_TABLE ON $BOOK_TABLE.$ID = $CART_TABLE.$BOOK_ID WHERE $USER_NAME = ?",[name]);
    print(maps);
    if(maps.length > 0){
      return List.generate(maps.length, (index) =>
          Book(
              bookId: maps[index]['id'],
              bookName: maps[index]['name'],
              bookDescription: maps[index]['description'],
              bookPrice: maps[index]['price'],
              rating: maps[index]['rating'],
              image: maps[index]['image']
          ));
    }else{
      return null;
    }
  }

  Future<List<Book>> getOrder(String name) async{
    print('order===');
    var dbClient = await db;
    List<Map> maps = await dbClient.rawQuery("SELECT $BOOK_TABLE.* FROM $BOOK_TABLE LEFT JOIN $ORDER_TABLE ON $BOOK_TABLE.$ID = $ORDER_TABLE.$BOOK_ID WHERE $USER_NAME = ?",[name]);
    if(maps.length > 0){
      return List.generate(maps.length, (index) =>
          Book(
              bookId: maps[index]['id'],
              bookName: maps[index]['name'],
              bookDescription: maps[index]['description'],
              bookPrice: maps[index]['price'],
              rating: maps[index]['rating'],
              image: maps[index]['image']
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
