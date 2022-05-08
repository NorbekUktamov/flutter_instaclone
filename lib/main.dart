import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_instaclone/theme/colors.dart';
import 'package:hive_flutter/hive_flutter.dart';


import 'package:flutter_instaclone/pages/login_pages/signin_page.dart';
import 'package:flutter_instaclone/pages/login_pages/signup_page.dart';
import 'package:flutter_instaclone/pages/login_pages/splash_page.dart';
import 'pages/main_pages/home_page.dart';
import 'services/hive_db_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox(HiveService.DB_NAME);
  await Firebase.initializeApp();

  // notification
  var initAndroidSetting = const AndroidInitializationSettings('@mipmap/ic_launcher');
  var initIosSetting = const IOSInitializationSettings();
  var initSetting = InitializationSettings(android: initAndroidSetting, iOS: initIosSetting);
  await FlutterLocalNotificationsPlugin().initialize(initSetting);

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instagram',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: ColorService.lightColor,
          elevation: 0.0,
        ),
      ),
      // themeMode: provider.themeMode,
      home: const SplashPage(),
      routes: {
        SplashPage.id: (context) => const SplashPage(),
        SignInPage.id: (context) => const SignInPage(),
        SignUpPage.id: (context) => const SignUpPage(),
        HomePage.id: (context) => const HomePage()
      },
    );
  }
}