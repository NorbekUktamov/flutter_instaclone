import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';

import '../models/user_model.dart';

class HiveDB{
  static String nameDB = "GK";
  static var box = Hive.box(nameDB);


  ///methods
  static putUser(UserModel user){
    box.put("user",user.toJson());
  }

  static UserModel getUser(){
    UserModel user =UserModel.fromJson(box.get("user"));
    return user;
  }

  static removeUser(){
    box.delete("user");
  }
}