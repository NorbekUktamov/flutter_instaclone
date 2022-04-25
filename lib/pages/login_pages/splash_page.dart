import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instaclone/models/user_model.dart';
import 'package:flutter_instaclone/pages/login_pages/signin_page.dart';
import 'package:flutter_instaclone/pages/main_pages/home_page.dart';
import 'package:flutter_instaclone/services/data_service.dart';
import 'package:flutter_instaclone/services/hive_db_service.dart';
import 'package:flutter_instaclone/widgets/splash_page_widgets.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);
  static String id = "/splash_page";

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late bool isLogin;

  _checkUser() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        setState(() {
          isLogin = false;
          Navigator.pushReplacementNamed(context, SignInPage.id);
        });
      } else {
        setState(() {
          isLogin = true;
          _getUser(user.uid);
        });
      }

    });
  }

  _getUser(String id)async{
      UserModel user = await DataService.getUser(id);
      HiveDB.putUser(user);
      Navigator.pushReplacementNamed(context, HomePage.id);
  }

  @override
  void initState() {
    super.initState();
    _checkUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          gradient: splashBackColor,
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: const [
            Center(
              child: InstaText(
                size: 45,
                color: Colors.white,
              ),
            ),
            Text(
              "All rights reserved",
              style: TextStyle(color: Colors.white, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
