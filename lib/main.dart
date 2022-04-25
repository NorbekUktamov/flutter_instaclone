import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_instaclone/pages/login_pages/signin_page.dart';
import 'package:flutter_instaclone/pages/login_pages/signup_page.dart';
import 'package:flutter_instaclone/pages/login_pages/splash_page.dart';
import 'package:flutter_instaclone/pages/main_pages/my_home_page.dart';
import 'package:flutter_instaclone/pages/main_pages/my_profile_page/edit_profile_page.dart';
import 'package:flutter_instaclone/services/http_service.dart';
import 'package:flutter_instaclone/services/user_notifire.dart';
import 'package:provider/provider.dart';

import 'pages/main_pages/home_page.dart';
import 'services/hive_db_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await Hive.openBox(HiveDB.nameDB);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  Provider.debugCheckInvalidValueType = null;
  runApp(ChangeNotifierProvider(create: (_) => UserNotifier(),child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  get controller => null;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        hintColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
            color: Colors.white, foregroundColor: Colors.black, elevation: 0),
        textTheme: const TextTheme(bodyText1: TextStyle(color: Colors.white)),
      ),
      home: const SplashPage(),
      routes: {
        HomePage.id: (context) => const HomePage(),
        MyHomePage.id: (context) =>  MyHomePage(controller: controller,),
        SplashPage.id: (context) => const SplashPage(),
        SignInPage.id: (context) => const SignInPage(),
        SignUpPage.id: (context) => const SignUpPage(),
        EditProfilePage.id: (context) => const EditProfilePage(),
      },
    );
  }
}
