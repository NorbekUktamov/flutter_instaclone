import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instaclone/models/user_model.dart';
import 'package:flutter_instaclone/services/data_service.dart';
import 'package:flutter_instaclone/services/hive_db_service.dart';
import 'package:flutter_instaclone/widgets/my_search_page_widgets.dart';
import 'package:flutter_instaclone/widgets/splash_page_widgets.dart';

class MySearchPage extends StatefulWidget {
  const MySearchPage({Key? key}) : super(key: key);

  @override
  State<MySearchPage> createState() => _MySearchPageState();
}

class _MySearchPageState extends State<MySearchPage> {
  TextEditingController searchController = TextEditingController();
  List<UserModel> listUsers = [];
  bool _isSearchingEmpty = true;

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      _onSearchChanged;
    });
  }

  _onSearchChanged() async {
    if (searchController.text.trim().isEmpty) {
      setState(() {
        _isSearchingEmpty = true;
      });
    } else {
      await DataService.searchUsers(searchController.text)
          .then((value) => setState(() {
                _isSearchingEmpty = false;
                listUsers = value;
              }));
    }
  }

  @override
  void dispose() {
    super.dispose();
    searchController.removeListener(() {
      _onSearchChanged;
    });
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const InstaText(size: 30, color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        children: [
          TextField(
            textAlignVertical: TextAlignVertical.center,
            controller: searchController,
            decoration: InputDecoration(
              hintText: "Search",
              prefixIcon: const Icon(Icons.search),
              fillColor: Colors.red,
              filled: true,
              isCollapsed: true,
              hintStyle: const TextStyle(color: Colors.black),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onChanged: (value) {
              _onSearchChanged();
            },
          ),
          const SizedBox(height: 10),
          _isSearchingEmpty
              ? StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection(DataService.userFolder)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: snapshot.data!.docs.map((DocumentSnapshot e) {
                          if (e["userName"] == HiveDB.getUser().userName) {
                            return const SizedBox.shrink();
                          }
                          return ListTile(
                            leading: const LeadingListTile(),
                            title: Text(
                              e["fullName"],
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            subtitle: const Text(
                              "Hi guys how are you ?",
                              style: TextStyle(fontSize: 12),
                            ),
                            trailing: TrailingListTile(isFollow: true),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 0),
                          );
                        }).toList(),
                      );
                    } else {
                      return Container();
                    }
                  })
              : Column(
                  children: listUsers
                      .map((e) => ListTile(
                            leading: const LeadingListTile(),
                            title: Text(
                              e.fullName,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            subtitle: const Text(
                              "Hi guys how are you ?",
                              style: TextStyle(fontSize: 12),
                            ),
                            trailing: TrailingListTile(isFollow: true),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 0),
                          ))
                      .toList(),
                ),
        ],
      ),
    );
  }
}
