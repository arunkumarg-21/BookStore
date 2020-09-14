
import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreference{



  Future<void> saveUser(String name,String password) async{
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('name', name);
    await sharedPreferences.setString('password', password);
  }

  Future<String> getUser() async{
    final sharedPreferences = await SharedPreferences.getInstance();
    String userCred;
    userCred=sharedPreferences.getString('name');
    if(userCred == null){
      return "noData";
    }
    return userCred;
  }
}

/*
class SharedPreference{


  saveUser(String name,String password) async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    sharedPreference.setString('password', password);
    return sharedPreference.setString('name', name);
  }



}*/
