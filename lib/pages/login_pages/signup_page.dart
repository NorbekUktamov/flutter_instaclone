import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_instaclone/models/user_model.dart';
import 'package:flutter_instaclone/pages/login_pages/signin_page.dart';
import 'package:flutter_instaclone/services/data_service.dart';
import 'package:flutter_instaclone/services/hive_db_service.dart';

import '../../services/auth_service.dart';
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

  _doSignUp() {
    String fullName = fullNameController.text.toString().trim();
    String userName = userNameController.text.toString().trim();
    String email = emailController.text.toString().trim();
    String password = passwordController.text.toString().trim();
    String cpassword = passwordController.text.toString().trim();

    // if (fullName.isEmpty ||
    //     userName.isEmpty ||
    //     email.isEmpty ||
    //     password.isEmpty) {
    //   setState(() {
    //     errorShow = true;
    //   });
    //   return;
    // }
    // if(password!=cpassword){
    //   setState(() {
    //     errorShow=true;
    //   });
    //   return;
    // }

    if(userName.isEmpty || email.isEmpty || password.isEmpty || cpassword.isEmpty){
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
    else if(password != cpassword){
      Utils.snackBar(context, 'Confirm password correctly, please!', ColorService.snackBarColor);
      setState(() {
        isLoading = false;
      });
      return;
    }


    AuthService.signUpUser(password: password, email: email, name: fullNameController.text)
        .then((value) {
      if (value != null) {
        UserModel user = UserModel(
            id: value.uid,
            fullName: fullNameController.text,
            userName: userName,
            email: email,
            password: password,
            userImg: null);
        HiveDB.putUser(user);
        DataService.putUser(user);
        Navigator.pushReplacementNamed(context, HomePage.id);
      } else {
        _checkErrorFireBase();
      }
    });
  }

  _checkErrorFireBase() async {
    String email = emailController.text.toString().trim();
    String password = passwordController.text.toString().trim();
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      errorToast(msg: e.message);
    }
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
