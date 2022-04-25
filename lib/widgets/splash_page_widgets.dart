import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';

import '../pages/main_pages/home_page.dart';
import '../services/auth_service.dart';

class InstaText extends StatelessWidget {
  final double size;
  final Color color;

  const InstaText({Key? key, required this.size, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      "Instagram",
      style: TextStyle(
        color: color,
        fontFamily: "Billabong",
        fontSize: size,
      ),
    );
  }
}

LinearGradient splashBackColor = const LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color.fromRGBO(252, 175, 69, 1),
    Color.fromRGBO(247, 119, 55, 1),
  ],
);

LinearGradient logoBorderColor = const LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    // Color.fromRGBO(64, 93, 230, 1),
    // Color.fromRGBO(88, 81, 219, 1),
    // Color.fromRGBO(131, 58, 180, 1),
    // Color.fromRGBO(193, 53, 132, 1),
    // Color.fromRGBO(225, 48, 108, 1),
    // Color.fromRGBO(253, 29, 29, 1),
    Color.fromRGBO(245, 96, 64, 1),
    Color.fromRGBO(247, 119, 55, 1),
    Color.fromRGBO(252, 175, 69, 1),
    Color.fromRGBO(255, 220, 128, 1),
  ],
);

errorToast({msg}) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}

class TextFieldLogin extends StatefulWidget {
  final String text;
  final TextEditingController controller;
  final bool errorShow;

  const TextFieldLogin({
    Key? key,
    required this.text,
    required this.controller,
    required this.errorShow,
  }) : super(key: key);

  @override
  State<TextFieldLogin> createState() => _TextFieldLoginState();
}

class _TextFieldLoginState extends State<TextFieldLogin> {
  _errorText(String text) {
    if (text.trim().toString().isEmpty) {
      return "Can't be empty";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _errorText(widget.controller.text) == null || !widget.errorShow
          ? 50
          : 80,
      child: TextField(
        controller: widget.controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: widget.text,
          errorText:
              widget.errorShow ? _errorText(widget.controller.text) : null,
          hintStyle: const TextStyle(fontSize: 14, color: Colors.white70),
          isCollapsed: true,
          contentPadding: const EdgeInsets.all(15),
          fillColor: Colors.white54.withOpacity(0.2),
          filled: true,
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red)),
        ),
        onChanged: (_) => setState(() {}),
      ),
    );
  }
}
