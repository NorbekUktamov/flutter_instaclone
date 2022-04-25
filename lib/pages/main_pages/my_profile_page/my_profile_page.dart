import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instaclone/models/user_model.dart';
import 'package:flutter_instaclone/pages/main_pages/my_profile_page/custom_header.dart';
import 'package:flutter_instaclone/pages/main_pages/my_profile_page/custom_tap_bar.dart';
import 'package:flutter_instaclone/services/user_notifire.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../../services/data_service.dart';
import '../../../services/hive_db_service.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({Key? key}) : super(key: key);

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  List<String> list2 = [];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<UserNotifier>(
      builder: (context, provider, _) => DefaultTabController(
        length: 2,
        child:Scaffold(
          backgroundColor: Colors.black,
          body: Container(
            child:NestedScrollView(
              headerSliverBuilder: (context, index) {
                return [
                  SliverAppBar(
                    backgroundColor: Colors.black,
                    pinned: true,
                    title: Text(
                      provider.userM.userName,
                      style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                    ),
                    actions: [
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(CupertinoIcons.plus_app,color: Colors.white,)),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          CupertinoIcons.bars,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SliverToBoxAdapter(child: CustomHeader()),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: CustomTapBar(maxEx: 47, minEx: 47),
                  ),
                ];
              },
              body: TabBarView(
                children: [
                  CustomScrollView(
                    slivers: [
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection(DataService.userFolder)
                            .doc(provider.userM.id)
                            .collection(DataService.postFolder)
                            .snapshots(),
                        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) =>
                            SliverGrid(
                              gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 2,
                                mainAxisSpacing: 2,
                              ),
                              delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                  return !snapshot.hasData
                                      ? Container()
                                      : Image.network(
                                      snapshot.data!.docs[index]["postImage"],
                                      fit: BoxFit.cover);
                                },
                                childCount:
                                snapshot.hasData ? snapshot.data!.docs.length : 0,
                              ),
                            ),
                      ),
                    ],
                  ),
                  CustomScrollView(
                    slivers: [
                      SliverGrid(
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3),
                        delegate: SliverChildBuilderDelegate(
                              (context, index) {
                            return list2.isEmpty
                                ? Container()
                                : Image.asset(list2[index]);
                          },
                          childCount: list2.length,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
