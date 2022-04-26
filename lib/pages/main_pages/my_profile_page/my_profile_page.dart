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
  List<String> list2 = [
    "https://images.unsplash.com/photo-1602526429747-ac387a91d43b?ixid=MXwxMjA3fDF8MHxlZGl0b3JpYWwtZmVlZHwxfHx8ZW58MHx8fA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "https://images.unsplash.com/photo-1609587293767-380ca047a28f?ixid=MXwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw0fHx8ZW58MHx8fA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "https://images.unsplash.com/photo-1609534356473-d92a626e780b?ixid=MXwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwxOHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "https://images.unsplash.com/photo-1609587674073-4bf65346ec56?ixid=MXwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwyNHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "https://images.unsplash.com/photo-1609531077736-e85fabbddccf?ixid=MXwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwzNHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "https://images.unsplash.com/photo-1609531001611-39aaf75acdb3?ixid=MXwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwzMnx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "https://images.unsplash.com/photo-1498050108023-c5249f4df085?ixid=MXwxMjA3fDB8MHxzZWFyY2h8Nnx8dGVjaG5vbG9neXxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "https://images.unsplash.com/photo-1593642634315-48f5414c3ad9?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MTB8fHRlY2hub2xvZ3l8ZW58MHx8MHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "https://images.unsplash.com/photo-1538391543564-047a76156421?ixid=MXwxMjA3fDB8MHxzZWFyY2h8Mjl8fHRlY2hub2xvZ3l8ZW58MHx8MHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "https://images.unsplash.com/photo-1497215842964-222b430dc094?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NDl8fHRlY2hub2xvZ3l8ZW58MHx8MHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
  ];

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
                            crossAxisCount: 2,
                        ),
                        delegate: SliverChildBuilderDelegate(
                              (context, index) {
                            return list2.isEmpty
                                ? Container()
                                : Image.network(list2[index]);
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
