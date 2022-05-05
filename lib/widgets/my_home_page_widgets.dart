import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'splash_page_widgets.dart';

class HeaderCircleBoxAndText extends StatelessWidget {
  const HeaderCircleBoxAndText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 70,
          width: 70,
          padding: const EdgeInsets.all(2),
          margin: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
            gradient: logoBorderColor,
          ),
          child: const CircleAvatar(
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 29,
              backgroundImage: NetworkImage(
                  ""),
            ),
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          "",
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}

class HeaderYourStory extends StatelessWidget {
  const HeaderYourStory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 70,
          width: 70,
          alignment: Alignment.bottomRight,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage("assets/images/ic_person.png"),
            ),
          ),
          child: const CircleAvatar(
            radius: 11,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 9,
              backgroundColor: Colors.blueAccent,
              child: Center(
                child: Text("+",
                    style: TextStyle(fontSize: 12, color: Colors.white)),
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          "Your story",
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}

class FooterIcons extends StatelessWidget {
  final IconData icon;
  const FooterIcons({Key? key,required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon:  FaIcon(
        icon,
        size: 20,
        color: Colors.white,
      ),
    );
  }
}
