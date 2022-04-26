import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instaclone/pages/main_pages/my_profile_page/edit_profile_page.dart';
import '../../../services/hive_db_service.dart';
import '../../../theme/colors.dart';
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
                  GestureDetector(
                    child:SizedBox(
                      width: (size.width - 20) * 0.3,
                      child: Stack(
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
                          Positioned(
                            bottom: 0,
                            right: 25,
                            child: Container(
                              height: 25,
                              width: 25,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black,
                                  border: Border.all(width: 1, color: Colors.white)
                              ),
                              child: Center(
                                child: Icon(Icons.add, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: (){
                      Navigator.pushNamed(context, EditProfilePage.id)
                          .then((value) {
                        setState(() {});
                      });
                    },
                  ),


                  SizedBox(width: size.width * 0.08),
                  PostsAndFollowAndFollowing(
                      text: "Posts", number: HiveDB.box.get("postLength") ?? "0"),
                  const PostsAndFollowAndFollowing(
                      text: "Followers", number: "100"),
                  const PostsAndFollowAndFollowing(
                      text: "Following", number: "50"),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                HiveDB.getUser().fullName,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 13,color: Colors.white),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MaterialButton(
                      height: 34,
                      minWidth: MediaQuery.of(context).size.width * 0.25,
                      shape: const RoundedRectangleBorder(
                        side: BorderSide(color: Colors.grey),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, EditProfilePage.id)
                            .then((value) {
                          setState(() {});
                        });
                      },
                      child: const Text(
                        'Edit profile',
                        textAlign: TextAlign.center,
                        style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15,color: Colors.white),
                      ),
                    ),
                    MaterialButton(
                      height: 34,
                      minWidth: MediaQuery.of(context).size.width * 0.25,
                      shape: const RoundedRectangleBorder(
                        side: BorderSide(color: Colors.grey),
                      ),
                      onPressed: () {},
                      child: const Text(
                        'Tools',
                        textAlign: TextAlign.center,
                        style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15,color: Colors.white),
                      ),
                    ),
                    MaterialButton(
                      height: 34,
                      minWidth: MediaQuery.of(context).size.width * 0.25,
                      shape: const RoundedRectangleBorder(
                        side: BorderSide(color: Colors.grey),
                      ),
                      onPressed: () {},
                      child: const Text(
                        'Chat',
                        textAlign: TextAlign.center,
                        style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15,color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),

          

              const SizedBox(height: 10),
              Column(
                children: const [
                  CircleAvatar(
                    radius: 33,
                    backgroundColor: Colors.grey,
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
                    "Story",
                    style: TextStyle(fontSize: 13,color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                height: 0.5,
                width: size.width,
                decoration: BoxDecoration(color: Colors.grey.withOpacity(0.8)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20)
      ],
    );
  }
}
