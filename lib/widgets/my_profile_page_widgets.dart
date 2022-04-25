import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostsAndFollowAndFollowing extends StatefulWidget {
  final String number;
  final String text;

  const PostsAndFollowAndFollowing(
      {Key? key, required this.text, required this.number})
      : super(key: key);

  @override
  State<PostsAndFollowAndFollowing> createState() =>
      _PostsAndFollowAndFollowingState();
}

class _PostsAndFollowAndFollowingState
    extends State<PostsAndFollowAndFollowing> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            widget.number,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            widget.text,
            style: TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class TextFieldEditProfile extends StatefulWidget {
  final String text;
  final TextEditingController controller;
  final bool errorShow;

  const TextFieldEditProfile({
    Key? key,
    required this.text,
    required this.controller,
    required this.errorShow,
  }) : super(key: key);

  @override
  State<TextFieldEditProfile> createState() => _TextFieldEditProfileState();
}

class _TextFieldEditProfileState extends State<TextFieldEditProfile> {
  _errorText(String text) {
    if (text.trim().toString().isEmpty) {
      return "Can't be empty";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.text,
        errorText: widget.text == "Bio"
            ? null
            : widget.errorShow
                ? _errorText(widget.controller.text)
                : null,
        labelStyle: TextStyle(color: Colors.grey),
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        errorBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        focusedErrorBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
      ),
      onChanged: (_) => setState(() {}),
    );
  }
}
