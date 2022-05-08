import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instaclone/models/user_model.dart';
import 'package:flutter_instaclone/pages/login_pages/signin_page.dart';
import 'package:flutter_instaclone/pages/main_pages/home_page.dart';

import 'package:flutter_instaclone/services/hive_db_service.dart';
import 'package:flutter_instaclone/widgets/splash_page_widgets.dart';

import '../../services/utils.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);
  static String id = "/splash_page";

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Widget _openNextPage() {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, value) {
        if(value.hasData) {
          HiveService.storeUID(value.data!.uid);
          return const HomePage();
        } else {
          HiveService.removeUid();
          return const SignInPage();
        }
      },
    );
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Utils.initNotification();
    // Future.delayed(Duration.zero, () async {
    //   await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    // });
    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => _openNextPage()));
    });
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
