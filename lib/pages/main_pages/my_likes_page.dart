import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instaclone/services/firestore_service.dart';
import 'package:flutter_instaclone/services/utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_instaclone/services/auth_service.dart';

import 'package:flutter_instaclone/services/hive_db_service.dart';


import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../models/post_model.dart';

import '../../widgets/appBar.dart';
import 'my_user_page.dart';


class LikesPage extends StatefulWidget {
  static const String id = '/likes_page';
  const LikesPage({Key? key}) : super(key: key);

  @override
  State<LikesPage> createState() => _LikesPageState();
}

class _LikesPageState extends State<LikesPage> {
  bool isLoading = false;
  List<Post> posts = [];

  void _apiLoadLikes() {
    setState(() {
      isLoading = true;
    });
    FirestoreService.loadLikes().then((value) => {_resLoadLikes(value)});
  }

  void _resLoadLikes(List<Post> _posts) {
    setState(() {
      posts = _posts;
      isLoading = false;
    });
  }

  void _actionRemovePost(Post post) async {
    var result = await Utils.dialog(context, 'Instagram',
        "Are you sure you want to remove this post?", false);
    if (result) {
      setState(() {
        isLoading = true;
      });
      await FirestoreService.likePost(post, false);
      await FirestoreService.removePost(post)
          .then((value) => {_apiLoadLikes()});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiLoadLikes();
  }

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(text: 'Likes', isCentered: true),
        body: Stack(
          children: [
            posts.isNotEmpty
                ? ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: posts.length,
              itemBuilder: (BuildContext context, int index) {
                return likesWidget(posts[index]);
              },
            )
                : const Center(
              child: Text('No liked posts',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      fontSize: 18)),
            ),
            isLoading
                ? const Center(child: CircularProgressIndicator.adaptive())
                : const SizedBox.shrink()
          ],
        ));
  }

  Widget likesWidget(Post post) {
    return ListTile(
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      onTap: () {
        if (!post.isMine) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      UserProfilePage(uid: post.uid!)));
        }
      },
      onLongPress: () {
        _actionRemovePost(post);
      },
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(50.0),
        child: post.profileImage == null
            ? Image.asset(
          'assets/profile_pictures/user.png',
          height: 45,
          width: 45,
          fit: BoxFit.cover,
        )
            : CachedNetworkImage(
          imageUrl: post.profileImage!,
          placeholder: (context, url) =>
              Image.asset('assets/profile_pictures/user.png'),
          errorWidget: (context, url, error) =>
              Image.asset('assets/profile_pictures/user.png'),
          height: 45,
          width: 45,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(post.username ?? 'User',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white)),
      subtitle: Text(post.caption,
          style: const TextStyle(fontSize: 16,color: Colors.white),
          overflow: TextOverflow.ellipsis,
          maxLines: 1),
      trailing: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: CachedNetworkImage(
          imageUrl: post.image,
          placeholder: (context, url) =>
          const Center(child: CircularProgressIndicator.adaptive()),
          errorWidget: (context, url, error) => const Icon(Icons.error,color: Colors.white,),
          height: 200,
          width: 100,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}