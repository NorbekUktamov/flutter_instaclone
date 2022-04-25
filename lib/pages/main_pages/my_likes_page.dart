import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_instaclone/services/auth_service.dart';
import 'package:flutter_instaclone/services/data_service.dart';
import 'package:flutter_instaclone/services/hive_db_service.dart';
import 'package:flutter_instaclone/widgets/my_home_page_widgets.dart';
import 'package:flutter_instaclone/widgets/splash_page_widgets.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../services/user_notifire.dart';

class MyLikesPage extends StatefulWidget {
  static String id = "/my_likes_page";
  const MyLikesPage({Key? key}) : super(key: key);

  @override
  State<MyLikesPage> createState() => _MyLikesPageState();
}

class _MyLikesPageState extends State<MyLikesPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserNotifier>(
      builder: (context, provider, _) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const InstaText(size: 30, color: Colors.white),

        ),
        body: ListView(
          shrinkWrap: true,
          children: [
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
