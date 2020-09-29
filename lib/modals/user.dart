
class User{
  final int userId;
  final String userName;
  final String userEmail;
  final String userPassword;
  final String userAddress;
  final String userAddress1;

  User({this.userId,this.userName,this.userEmail,this.userPassword,this.userAddress,this.userAddress1});

  Map<String,dynamic> userToMap(){
    var map = <String,dynamic>{
      'id' : userId,
      'name' : userName,
      'email' : userEmail,
      'password' : userPassword,
      'Address' : userAddress,
      'Address1' : userAddress1
    };
    return map;
  }

}