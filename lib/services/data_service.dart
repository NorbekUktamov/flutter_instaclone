import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_instaclone/models/post_model.dart';
import 'package:flutter_instaclone/models/user_model.dart';
import 'package:flutter_instaclone/services/hive_db_service.dart';

class DataService {
  static final instance = FirebaseFirestore.instance;

  //folder
  static const String userFolder = "users";
  static const String postFolder = "posts";

  static Future putUser(UserModel user) async {
    return instance.collection(userFolder).doc(user.id).set(user.toJson());
  }

  static Future<UserModel> getUser(String uid) async {
    DocumentSnapshot<Map<String, dynamic>> map =
        await instance.collection(userFolder).doc(uid).get();
    return UserModel.fromJson(map.data()!);
  }

  static Future updateUser(UserModel user) async {
    return instance.collection(userFolder).doc(user.id).update(user.toJson());
  }

  static Future searchUsers(String keyword) async {
    List<UserModel> users = [];
    await instance
        .collection(userFolder)
        .orderBy("fullName")
        .startAt([keyword])
        .endAt([keyword + '\uf8ff'])
        .get()
        .then((value) {
          for (var user in value.docs) {
            if (UserModel.fromJson(user.data()).userName !=
                HiveDB.getUser().userName) {
              users.add(UserModel.fromJson(user.data()));
            }
          }
        });
    return users;
  }

  static Future<bool> putPost(Post post)async{
    String postId = instance.collection(userFolder).doc(post.id).collection(postFolder).doc().id;
    await instance.collection(userFolder).doc(post.id).collection(postFolder).doc(postId).set(post.toJson());
    return true;
  }
}
