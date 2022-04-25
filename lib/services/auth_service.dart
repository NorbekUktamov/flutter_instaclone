import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instaclone/services/hive_db_service.dart';
import 'package:flutter_instaclone/widgets/splash_page_widgets.dart';
import 'package:logger/logger.dart';
import '../pages/login_pages/signin_page.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<User?> signUpUser({name, email, password}) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      if (user != null) await user.updateDisplayName(name);
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Logger().w('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        Logger().w('The account already exists for that email.');
      }
    } catch (e) {
      Logger().w(e);
    }
    return null;
  }

  static Future<User?> signInUser({email, password}) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      return userCredential.user;
    } on FirebaseAuthException catch  (e) {
      if(e.code == "user-not-found"){
        errorToast(msg: "User was not found in the database");
      }
      if (e.code == 'weak-password') {
        errorToast(msg: 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        errorToast(msg: 'The account already exists for that email.');
      }
    }
  }

  static void signOutUser(BuildContext context) async {
    await _auth.signOut().then(
        (value) => Navigator.pushReplacementNamed(context, SignInPage.id));
  }
}
