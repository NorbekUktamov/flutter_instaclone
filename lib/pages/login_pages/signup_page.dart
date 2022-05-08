import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_instaclone/models/user_model.dart';
import 'package:flutter_instaclone/pages/login_pages/signin_page.dart';

import 'package:flutter_instaclone/services/hive_db_service.dart';

import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../services/utils.dart';
import '../../theme/colors.dart';
import '../../widgets/splash_page_widgets.dart';
import '../main_pages/home_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);
  static String id = "/signup_page";

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cpasswordController = TextEditingController();
  bool errorShow = false;
  bool isLoading =false;


  void _doSignUp() async{
    String fullname = fullNameController.text.toString().trim();
    String username = userNameController.text.toString().trim();
    String email = emailController.text.toString().trim();
    String password = passwordController.text.toString().trim();
    String confirmPassword = cpasswordController.text.toString().trim();
    if(username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty){
      Utils.snackBar(context, 'Fill in the fields, please!', ColorService.snackBarColor);
      setState(() {
        isLoading = false;
      });
      return;
    }
    else if (Utils.validateEmail(email) == false) {
      Utils.snackBar(context, 'Enter a valid email address, please!', ColorService.snackBarColor);
      setState(() {
        isLoading = false;
      });
      return;
    }
    else if (Utils.validatePassword(password) == false) {
      Utils.snackBar(context, 'Password must contain at least one upper case, one lower case, one digit, one special character and be at least 8 characters in length', ColorService.snackBarColor);
      setState(() {
        isLoading = false;
      });
      return;
    }
    else if(password != confirmPassword){
      Utils.snackBar(context, 'Confirm password correctly, please!', ColorService.snackBarColor);
      setState(() {
        isLoading = false;
      });
      return;
    }

    UserModel user = UserModel(username: username, email: email, password: password, fullname: fullname,);
    await AuthenticationService.signUpUser(context, username, email, password,fullname,)
        .then((value) => _getFirebaseUser(user, value));

  }

  void _getFirebaseUser(UserModel userModel, User? user) {
    if (user != null) {
      HiveService.storeUID(user.uid);
      FirestoreService.storeUser(userModel).then((value) => Navigator.pushReplacementNamed(context, HomePage.id));
    } else {
      Utils.snackBar(context, 'Check your data, please!', ColorService.snackBarColor);
    }
    setState(() {
      isLoading = false;
    });
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
                const InstaText(
                  size: 45,
                  color: Colors.white,
                ),
                const SizedBox(height: 20),
                TextFieldLogin(
                  text: "Full Name",
                  controller: fullNameController,
                  errorShow: errorShow,
                ),
                const SizedBox(height: 10),
                TextFieldLogin(
                  text: "Username",
                  controller: userNameController,
                  errorShow: errorShow,
                ),
                const SizedBox(height: 10),
                TextFieldLogin(
                  text: "Email",
                  controller: emailController,
                  errorShow: errorShow,
                ),
                const SizedBox(height: 10),
                TextFieldLogin(
                  text: "Password",
                  controller: passwordController,
                  errorShow: errorShow,
                ),
                const SizedBox(height: 10),
                TextFieldLogin(
                  text: "Confirm Password",
                  controller: cpasswordController,
                  errorShow: errorShow,
                ),
                const SizedBox(height: 10),

                buttonSignUp(),
              ],
            ),

            ///bottom text
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Already have an account?",
                  style: TextStyle(color: Colors.white),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, SignInPage.id);
                  },
                  child: const Text(
                    "Sign In",
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

  Widget buttonSignUp() {
    return MaterialButton(
      onPressed: _doSignUp,
      child: const Text("Sign Up"),
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
