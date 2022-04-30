import 'package:flutter/material.dart';
import 'package:flutter_instaclone/pages/login_pages/signup_page.dart';
import 'package:flutter_instaclone/services/data_service.dart';
import 'package:flutter_instaclone/services/hive_db_service.dart';
import 'package:flutter_instaclone/widgets/splash_page_widgets.dart';
import '../../services/auth_service.dart';
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
  bool errorShow = false;

  _doSignIn() {
    String email = emailController.text.toString().trim();
    String password = passwordController.text.toString().trim();
    if (email.isEmpty || password.isEmpty) {
      setState(() {
        errorShow = true;
      });
      return;
    }
    AuthService.signInUser(password: password, email: email)
        .then((value) async {
      if (value != null) {
        await DataService.getUser(value.uid)
            .then((value) => HiveDB.putUser(value));
        Navigator.pushReplacementNamed(context, HomePage.id);
      } else {
        _checkError();
      }
    });
  }

  _checkError() async {
    errorToast(msg: "Check your email or password");
  }

  @override
  void dispose() {
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
