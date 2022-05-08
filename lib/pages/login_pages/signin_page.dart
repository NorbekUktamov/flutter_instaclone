import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instaclone/pages/login_pages/signup_page.dart';
import 'package:flutter_instaclone/services/hive_db_service.dart';
import 'package:flutter_instaclone/widgets/splash_page_widgets.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../services/utils.dart';
import '../../theme/colors.dart';
import '../main_pages/home_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);
  static String id = "/signin_page";

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool errorShow=false;



  void _doSignIn() async {
    String email = emailController.text.trim().toString();
    String password = passwordController.text.trim().toString();

    if (email.isEmpty || password.isEmpty) {
      Utils.snackBar(context, 'Fill in the fields, please!', ColorService.snackBarColor);
      setState(() {
        isLoading = false;
      });
      return;
    }

    await AuthenticationService.signInUser(context, email, password)
        .then((value) => _getFirebaseUser(value));
  }

  void _getFirebaseUser(User? user) {
    if (user != null) {
      HiveService.storeUID(user.uid);
      _apiUpdateUser();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    }
    setState(() {
      isLoading = false;
    });
  }

  void _apiUpdateUser() async {
    UserModel user = await FirestoreService.loadUser(null);
    user.deviceToken = HiveService.getToken();
    await FirestoreService.updateUser(user);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Utils.initNotification();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: splashBackColor,
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ///body center
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: double.infinity),
                const InstaText(size: 45, color: Colors.white),
                const SizedBox(height: 20),
                TextFieldLogin(
                    text: "Email",
                    controller: emailController,
                    errorShow: errorShow),
                const SizedBox(height: 10),
                TextFieldLogin(
                    text: "Password",
                    controller: passwordController,
                    errorShow: errorShow),
                const SizedBox(height: 10),
                buttonSignIn(),
              ],
            ),

            ///bottom text
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account?",
                  style: TextStyle(color: Colors.white),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, SignUpPage.id);
                  },
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buttonSignIn() {
    return MaterialButton(
      onPressed: _doSignIn,
      child: const Text("Sign In"),
      textColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        side: const BorderSide(color: Colors.white54),
      ),
      minWidth: double.infinity,
      height: 50,
    );
  }
}
