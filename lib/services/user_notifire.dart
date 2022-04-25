import 'package:flutter/cupertino.dart';
import 'package:flutter_instaclone/models/user_model.dart';
import 'package:flutter_instaclone/services/hive_db_service.dart';

class UserNotifier with ChangeNotifier{
  UserModel userM = HiveDB.getUser();

  updateUser(UserModel user){
    userM = user;
    notifyListeners();
  }
}