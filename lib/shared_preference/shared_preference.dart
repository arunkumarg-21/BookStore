
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
    userCred = (sharedPreferences.getString('name')??"noData");
    return userCred;
  }

  logOut() async{
    final sharedPreference = await SharedPreferences.getInstance();
    await sharedPreference.clear();
  }
}
