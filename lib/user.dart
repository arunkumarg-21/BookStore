
class User{
  final int userId;
  final String userName;
  final String userEmail;
  final String userPassword;
  final String userAddress;

  User({this.userId,this.userName,this.userEmail,this.userPassword,this.userAddress});

  Map<String,dynamic> userToMap(){
    var map = <String,dynamic>{
      'id' : userId,
      'name' : userName,
      'email' : userEmail,
      'password' : userPassword,
      'Address' : userAddress
    };
    return map;
  }

}