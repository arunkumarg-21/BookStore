import 'package:book_store/screens/cart/cart_screen.dart';
import 'package:book_store/screens/details/details_screen.dart';
import 'package:book_store/screens/home/components/body.dart';
import 'package:book_store/screens/home/components/icon_button.dart';
import 'package:book_store/screens/home/components/item_card.dart';
import 'package:book_store/shared_preference/shared_preference.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../constants.dart';
import '../../modals/book.dart';
import '../../database/db_helper.dart';
import '../login/login.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Book> books;
  bool isSearching = false;
  var dbHelper;
  int _currentIndex;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();

  }

  void insert() {
    var book1 = Book(
        bookName: 'Im Thinking of Ending Things',
        bookDescription:
            'The story is narrated by Jakes girlfriend of only a few months. '
            'They met in a pub during a college trivia night, and Jake gave her his phone number by writing it on a piece of paper and slipping it into her bag. '
            'Several weeks later he takes her to meet his parents on their remote farm. She has been considering "ending things," but has not told him yet. '
            'It is a long drive and they engage in lengthy philosophical discussions.',
        bookPrice: 120,
        rating: 4.5,
        image: 'assets/images/book1.jpg');
    dbHelper.saveBook(book1);
    var book2 = Book(
        bookName: 'Gone with the Wind',
        bookDescription:
            'Gone with the Wind takes place in the state of Georgia during the American Civil War (1861–1865) and '
            'the Reconstruction Era (1865–1877). The novel unfolds against the backdrop of a rebellion in which seven southern states – including Georgia',
        bookPrice: 150,
        rating: 3.0,
        image: 'assets/images/book2.jpg');
    dbHelper.saveBook(book2);
    var book3 = Book(
        bookName: 'The Godfather',
        bookDescription:
            'The Corleone family fights a mob war with the Five Families of the New York Mafia in the years after World War II.'
            ' After Don Vito Corleone is shot by men working for drug dealer Virgil "The Turk" Sollozzo, Corleones two sons, Santino ("Sonny") and '
            'Michael, must run the family business with the help of consigliere Tom Hagen and the two caporegimes Clemenza and Tessio. ',
        bookPrice: 220,
        rating: 3.9,
        image: 'assets/images/book3.jpg');
    dbHelper.saveBook(book3);
    var book4 = Book(
        bookName: 'Little Women',
        bookDescription:
            'Little Women is a novel by American author Louisa May Alcott (1832–1888) '
            'which was originally published in two volumes in 1868 and 1869. Alcott wrote the book over several months at the request of her publisher.'
            ' The story follows the lives of the four March sisters—Meg, Jo, Beth, and Amy—and details their passage from childhood to womanhood.',
        bookPrice: 220,
        rating: 4.0,
        image: 'assets/images/book4.jpeg');
    dbHelper.saveBook(book4);
    var book5 = Book(
        bookName: 'Schindlers Ark',
        bookDescription:
            'The book tells the story of Oskar Schindler, a member of the Nazi Party who becomes an unlikely hero by saving '
            'the lives of 1,100 Polish Jews during the Holocaust. It is a non-fiction novel which describes actual people and places, with fictional events, dialogue and '
            'scenes added by the author, and reconstructed dialogue where exact details are unknown.',
        bookPrice: 220,
        rating: 3.6,
        image: 'assets/images/book5.jpg');
    dbHelper.saveBook(book5);
    var book6 = Book(
        bookName: 'Fight club',
        bookDescription:
            'Fight Club is a 1996 novel by Chuck Palahniuk. It follows the experiences of an unnamed protagonist struggling with insomnia. '
            'Inspired by his doctors exasperated remark that insomnia is not suffering, the protagonist finds relief by impersonating a seriously ill person in several support groups. '
            'Then he meets a mysterious man named Tyler Durden and establishes an underground fighting club as radical psychotherapy.',
        bookPrice: 220,
        rating: 4.7,
        image: 'assets/images/book6.jpg');
    dbHelper.saveBook(book6);
    var book7 = Book(
        bookName: 'Rita Hayworth and Shawshank Redemption',
        bookDescription:
            'Rita Hayworth and Shawshank Redemption is a novella by Stephen King from his 1982 collection Different Seasons,'
            'subtitled Hope Springs Eternal. The story is entirely told by the character Red, in a narrative he claims to have been writing from September 1975 to January 1976,'
            ' with an additional chapter added in spring 1977.',
        bookPrice: 220,
        rating: 4.5,
        image: 'assets/images/book7.jpeg');
    dbHelper.saveBook(book7);
    var book8 = Book(
        bookName: 'To Kill a Mockingbird',
        bookDescription:
            'To Kill a Mockingbird is a novel by Harper Lee published in 1960.'
            ' Instantly successful, widely read in high schools and middle schools in the United States, it has become a classic of modern American literature,'
            ' winning the Pulitzer Prize. The plot and characters are loosely based on Lees observations of her family, '
            'her neighbors and an event that occurred near her hometown of Monroeville, Alabama, in 1936, when she was ten.',
        bookPrice: 220,
        rating: 4.8,
        image: 'assets/images/book8.jpg');
    dbHelper.saveBook(book8);
    var book9 = Book(
        bookName: 'The Silence of the Lambs',
        bookDescription:
            'The Silence of the Lambs is a psychological horror novel by Thomas Harris. First published in 1988,'
            ' it is the sequel to Harriss 1981 novel Red Dragon. Both novels feature the cannibalistic serial killer Dr. Hannibal Lecter, this time pitted against '
            'FBI Special Agent Clarice Starling. Its film adaptation directed by Jonathan Demme was released in 1991 to widespread critical acclaim and box office success.',
        bookPrice: 220,
        rating: 4.6,
        image: 'assets/images/book9.jpg');
    dbHelper.saveBook(book9);
    var book10 = Book(
        bookName: 'One Flew Over the Cuckoos Nest',
        bookDescription:
            'One Flew Over the Cuckoos Nest (1962) is a novel written by Ken Kesey.'
            ' Set in an Oregon psychiatric hospital, the narrative serves as a study of institutional processes and the human mind as well as a critique of behaviorism and '
            'a tribute to individualistic principles.[',
        bookPrice: 220,
        rating: 4.0,
        image: 'assets/images/book10.jpg');
    dbHelper.saveBook(book10);
    var book11 = Book(
        bookName: 'No Country for Old Men',
        bookDescription:
            'No Country for Old Men is a 2005 novel by American author Cormac McCarthy, '
            'who had originally written the story as a screenplay. The story occurs in the vicinity of the Mexico–United States border in 1980 and'
            ' concerns an illegal drug deal gone awry in the Texas desert back country. Owing to the novels origins as a screenplay,'
            ' the novel has a simple writing style different from other Cormac McCarthy novels. ',
        bookPrice: 220,
        rating: 3.8,
        image: 'assets/images/book11.jpg');
    dbHelper.saveBook(book11);
    var book12 = Book(
        bookName: 'American Psycho',
        bookDescription:
            'American Psycho is a novel by Bret Easton Ellis, published in 1991. '
            'The story is told in the first person by Patrick Bateman, a serial killer and Manhattan investment banker. '
            'Alison Kelly of The Observer notes that while "some countries [deem it] so potentially disturbing that it can only be sold shrink-wrapped", '
            '"critics rave about it" and "academics revel in its transgressive and postmodern qualities".',
        bookPrice: 220,
        rating: 4.1,
        image: 'assets/images/book12.jpeg');
    dbHelper.saveBook(book12);
    var book13 = Book(
        bookName: 'Requiem for a Dream',
        bookDescription:
            'This story follows the lives of Sara Goldfarb, her son Harry, his girlfriend Marion Silver,'
            ' and his best friend Tyrone C. Love, who are all searching for the key to their dreams in their own ways. In the process, they fall into devastating lives of addiction. '
            'Harry and Marion are in love and want to open their own business; their friend Tyrone wants to escape life in the ghetto. To achieve these dreams, '
            'they buy a large amount of heroin, planning to get rich by selling it.',
        bookPrice: 220,
        rating: 4.2,
        image: 'assets/images/book13.jpg');
    dbHelper.saveBook(book13);
    var book14 = Book(
        bookName: 'The Shining',
        bookDescription:
            'The Shining is a horror novel by American author Stephen King. Published in 1977, it is Kings third published novel and '
            'first hardback bestseller: the success of the book firmly established King as a preeminent author in the horror genre. The setting and '
            'characters are influenced by Kings personal experiences, including both his visit to The Stanley Hotel in 1974 and his struggle with alcoholism.'
            ' ',
        bookPrice: 220,
        rating: 4.4,
        image: 'assets/images/book14.jpg');
    dbHelper.saveBook(book14);
    var book15 = Book(
        bookName: 'Wiseguy',
        bookDescription:
            'Wiseguy: Life in a Mafia Family is a 1985 non-fiction book by crime reporter Nicholas Pileggi that chronicles '
            'the life of Henry Hill; a mafia mobster who turned informant.',
        bookPrice: 220,
        rating: 4.6,
        image: 'assets/images/book15.jpg');
    dbHelper.saveBook(book15);
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: Text('Are you sure?'),
        content:Text('Do you want to exit'),
        actions: <Widget>[
           FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child:  Text('No'),
          ),
           FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Yes'),
          ),
        ],
      ),
    )) ?? false;
  }

  @override
  Widget build(BuildContext context) {

    dbHelper.getBooks().then((value){
      if(value == null){
        setState(() {
          insert();
        });
      }
    }).catchError((e){
      print(e);
    });

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          backgroundColor: Color(0xFFF5F6F9),
          appBar: AppBar(
            elevation: 3,
            leading: Padding(padding:EdgeInsets.all(8),child: SvgPicture.asset('assets/icons/book.svg')),
            title: Text(AppName,
              style: TextStyle(
                  color: Colors.black,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),),
            backgroundColor: Color(0xFFF5F6F9),
            /*flexibleSpace: Center(
                child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: ,
                          ),
                          Expanded(
                            flex: 8,
                            child: Container(
                              padding: EdgeInsets.only(left: 16, top: 16),
                              child: Text(AppName,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                          ),
                        ],
                      )),*/
            actions: [
              IconBtnWithCounter(
                numOfitem: 0,
                press: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CartScreen())),
                svgSrc: 'assets/icons/Cart Icon.svg',
              )
            ],
          ),
          body: Body(),
        /*Column(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: FutureBuilder<List<Book>>(
                    future: fetchBookData(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return GridView.builder(
                            itemCount: snapshot.data.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        (orientation == Orientation.portrait)
                                            ? 2
                                            : 3,
                                    childAspectRatio: itemWidth/itemHeight,
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 20),
                            itemBuilder: (context, index) {
                              Book book = snapshot.data[index];
                              return ItemCard(
                                  book: book,
                                  //cartPress: () => insertCart(context,book),
                                  press: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DetailsScreen(book: book))));

                            });
                      }
                      return Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              )
            ],
          ),*/
      ),
    );
  }


  /*Future<List<Book>> fetchBookData() {
    final books = dbHelper.getBooks();
    return books;
  }*/

  /*insertCart(BuildContext context,Book book) async{
    var name;
    var sharedPref = MySharedPreference();
    await sharedPref.getUser().then((value) => name = value);
    if(name == 'noDate' || null){
      _showLoginDialog(context);
    }else{
      await dbHelper.insertCart(book.bookId,name);
    }

  }
*/
 /* _showLoginDialog(BuildContext context) async {
    await showDialog<String>(
      context: context,
      child: AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: new Text('Please Login To Purchase'),
            ),
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              }),
          new FlatButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                        (route) => false);
              })
        ],
      ),
    );
  }*/


}
