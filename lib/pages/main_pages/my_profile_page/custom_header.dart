import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instaclone/pages/main_pages/my_profile_page/edit_profile_page.dart';
import '../../../services/hive_db_service.dart';
import '../../../widgets/my_profile_page_widgets.dart';

class CustomHeader extends StatefulWidget {

  const CustomHeader({Key? key,}) : super(key: key);

  @override
  State<CustomHeader> createState() => _CustomHeaderState();
}

class _CustomHeaderState extends State<CustomHeader> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 3)],
                    ),
                    child: HiveDB.getUser().userImg != null
                        ? Image.network(
                            HiveDB.getUser().userImg!,
                            fit: BoxFit.cover,
                          )
                        : Image.asset("assets/images/img.png"),
                  ),
                  SizedBox(width: size.width * 0.08),
                  PostsAndFollowAndFollowing(
                      text: "Posts", number: HiveDB.box.get("postLength") ?? "0"),
                  const PostsAndFollowAndFollowing(
                      text: "Followers", number: "0"),
                  const PostsAndFollowAndFollowing(
                      text: "Following", number: "0"),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                HiveDB.getUser().fullName,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 13,color: Colors.white),
              ),
              const SizedBox(height: 10),
              MaterialButton(
                onPressed: () {
                  Navigator.pushNamed(context, EditProfilePage.id)
                      .then((value) {
                    setState(() {});
                  });
                },
                child: const Text("Edit profile",style: TextStyle(color: Colors.white),),
                minWidth: double.infinity,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: const BorderSide(color: Colors.white)),
              ),
              const SizedBox(height: 10),
              Column(
                children: const [
                  CircleAvatar(
                    radius: 33,
                    backgroundColor: Colors.black,
                    child: CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.black,
                      child: Icon(
                        CupertinoIcons.plus,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "New",
                    style: TextStyle(fontSize: 13,color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20)
      ],
    );
  }
}
