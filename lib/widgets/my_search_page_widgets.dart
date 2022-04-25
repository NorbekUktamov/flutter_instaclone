import 'package:flutter/material.dart';
import 'package:flutter_instaclone/widgets/splash_page_widgets.dart';

class LeadingListTile extends StatelessWidget {
  const LeadingListTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: logoBorderColor,
      ),
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: const CircleAvatar(
          backgroundColor: Colors.white,
          backgroundImage: AssetImage("assets/images/img.png"),
        ),
      ),
    );
  }
}

class TrailingListTile extends StatefulWidget {
  late bool isFollow;

  TrailingListTile({Key? key, required this.isFollow}) : super(key: key);

  @override
  State<TrailingListTile> createState() => _TrailingListTileState();
}

class _TrailingListTileState extends State<TrailingListTile> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        setState(() {
          widget.isFollow = !widget.isFollow;
        });
      },
      child: Text(
        widget.isFollow ? "Follow" : "Following",
        style: const TextStyle(fontSize: 12),
      ),
      textColor: widget.isFollow ? Colors.black : Colors.white,
      color: widget.isFollow ? Colors.white : Colors.blue,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        side: BorderSide(
          color: widget.isFollow ? Colors.black26 : Colors.transparent,
        ),
      ),
    );
  }
}
