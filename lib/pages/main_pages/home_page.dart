import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_instaclone/models/user_model.dart';
import 'package:flutter_instaclone/pages/main_pages/my_home_page.dart';
import 'package:flutter_instaclone/pages/main_pages/my_likes_page.dart';
import 'package:flutter_instaclone/pages/main_pages/my_post_page.dart';
import 'package:flutter_instaclone/pages/main_pages/my_profile_page/my_profile_page.dart';
import 'package:flutter_instaclone/pages/main_pages/my_search_page.dart';
import 'package:flutter_instaclone/services/hive_db_service.dart';
import 'package:flutter_instaclone/services/user_notifire.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static String id = "/home_page";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController pageController = PageController(initialPage: 0);
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          MyHomePage(),
          MySearchPage(),
          MyPostPage(),
          MyLikesPage(),
          MyProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: false,
        showSelectedLabels: false,
        backgroundColor: Colors.black,
        enableFeedback: false,
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });

          pageController.jumpToPage(index);
        },
        type: BottomNavigationBarType.fixed,
        selectedIconTheme: const IconThemeData(color: Colors.white),
        unselectedIconTheme: const IconThemeData(color: Colors.grey),
        items: const [
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.home), label: ""),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.search), label: ""),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.plusSquare), label: ""),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.heart), label: ""),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.userCircle), label: ""),
        ],
      ),
    );
  }




}
