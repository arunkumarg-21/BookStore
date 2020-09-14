
class User{
  final int userId;
  final String userName;
  final String userEmail;
  final String userPassword;

  User({this.userId,this.userName,this.userEmail,this.userPassword});

  Map<String,dynamic> userToMap(){
    var map = <String,dynamic>{
      'id' : userId,
      'name' : userName,
      'email' : userEmail,
      'password' : userPassword
    };
    return map;
  }

}