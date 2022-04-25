import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instaclone/pages/main_pages/my_post_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_instaclone/services/auth_service.dart';
import 'package:flutter_instaclone/services/data_service.dart';
import 'package:flutter_instaclone/services/hive_db_service.dart';
import 'package:flutter_instaclone/widgets/my_home_page_widgets.dart';
import 'package:flutter_instaclone/widgets/splash_page_widgets.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../services/user_notifire.dart';

class MyHomePage extends StatefulWidget {

  PageController controller;
   MyHomePage({Key? key, required this.controller,}) : super(key: key);
  static String id = "/my_home_page";

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserNotifier>(
      builder: (context, provider, _) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const InstaText(size: 30, color: Colors.white),
          actions: [
           IconButton(
                    onPressed: () {
                      widget.controller.jumpToPage(2);
                      Navigator.pushReplacementNamed(context, MyPostPage.id);
                    },
                    icon: const Icon(Icons.camera,color: Colors.red,),
                  ),

            Center(
              child: Padding(
                padding: const EdgeInsets.all(17.0),
                child: GestureDetector(
                    onTap: () {
                      AuthService.signOutUser(context);
                    },
                    child: Image.asset("assets/images/icon_messenger.png",color: Colors.red,)),
              ),
            ),
          ],
        ),
        body: ListView(
          shrinkWrap: true,
          children: [
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 10),
                children: const [
                  HeaderYourStory(),
                  HeaderCircleBoxAndText(),
                ],
              ),
            ),
            const Divider(),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection(DataService.userFolder)
                  .doc(provider.userM.id)
                  .collection(DataService.postFolder)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                Logger().i(snapshot.hasData);
                if (snapshot.hasData) {
                  HiveDB.box
                      .put("postLength", snapshot.data!.docs.length.toString());
                  return Column(
                    children: snapshot.data!.docs
                        .map(
                          (e) => Column(children: [
                            ///header
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Row(
                                children: [
                                  Container(
                                    height: 30,
                                    width: 30,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle),
                                    child: provider.userM.userImg == null
                                        ? Image.asset("assets/images/img.png")
                                        : Image.network(
                                            provider.userM.userImg!),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(provider.userM.userName,style: const TextStyle(color: Colors.white),),
                                  const Spacer(),
                                  GestureDetector(
                                      onTap: () {},
                                      child: const Icon(Icons.more_vert,color: Colors.white,)),
                                ],
                              ),
                            ),

                            ///image
                            Image.network(
                              e["postImage"],
                              height: 300,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),

                            ///footer
                            Row(
                              children: const [
                                FooterIcons(icon: FontAwesomeIcons.heart),
                                FooterIcons(icon: FontAwesomeIcons.comment),
                                FooterIcons(icon: FontAwesomeIcons.paperPlane),
                                Spacer(),
                                FooterIcons(icon: FontAwesomeIcons.bookmark),
                              ],
                            ),

                            ///caption
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    provider.userM.userName + "  ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                                  ),
                                  Text(e["caption"],style: TextStyle(color: Colors.white),),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                          ]),
                        )
                        .toList(),
                  );
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}
