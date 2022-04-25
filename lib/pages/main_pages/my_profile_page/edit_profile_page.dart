import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_instaclone/models/user_model.dart';
import 'package:flutter_instaclone/services/data_service.dart';
import 'package:flutter_instaclone/services/hive_db_service.dart';
import 'package:flutter_instaclone/services/storage_service.dart';
import 'package:flutter_instaclone/services/user_notifire.dart';
import 'package:flutter_instaclone/widgets/my_profile_page_widgets.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../home_page.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);
  static String id = "/edit_profile_page";

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();

  bool load = false;
  bool errorShow = false;
  File? _img;
  final picker = ImagePicker();

  _getPhoto() async {
    await picker.pickImage(source: ImageSource.gallery).then((value) {
      if (value != null) {
        setState(() {
          _img = File(value.path);
        });
      } else {
        Logger().d("No image selected");
      }
    });
  }

  _saveEdit(UserNotifier provider) {
    String name = nameController.text.trim();
    String userName = userNameController.text.trim();

    if (name.isEmpty || userName.isEmpty) {
      setState(() {
        errorShow = true;
      });
      return;
    }
    setState(() {
      load = true;
    });

    _putImage(provider);
  }

  _putImage(UserNotifier provider) async {
    await StorageService.uploadImg(_img, StorageService.folderUserImg,
            oldUrl: HiveDB.getUser().userImg)
        .then((value) => _putUser(value, provider));
  }

  _putUser(String? value, UserNotifier provider) async {
    UserModel newUser = UserModel(
      id: HiveDB.getUser().id,
      fullName: nameController.text,
      userName: userNameController.text,
      email: HiveDB.getUser().email,
      password: HiveDB.getUser().password,
      userImg: HiveDB.getUser().userImg != null
          ? value ?? HiveDB.getUser().userImg!
          : value,
    );
    await DataService.updateUser(newUser).then((value) {
      HiveDB.putUser(newUser);
      provider.updateUser(newUser);
      setState(() {
        load = false;
      });
      Navigator.pop(context);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.text = HiveDB.getUser().fullName;
    userNameController.text = HiveDB.getUser().userName;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    userNameController.dispose();
    bioController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserNotifier>(
      builder: (context, provider, child) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(CupertinoIcons.clear, size: 25),
          ),
          title: const Text("Edit Profile"),
          actions: [
            IconButton(
                onPressed: () {
                  _saveEdit(provider);
                },
                icon: const Icon(CupertinoIcons.check_mark, size: 25))
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          children: [
            const SizedBox(height: 5),
            Column(
              children: [
                load
                    ? LinearProgressIndicator(color: Colors.yellow)
                    : SizedBox.shrink(),
                SizedBox(height: 15),
                Container(
                  height: 120,
                  width: 120,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 3)],
                  ),
                  child: _img != null
                      ? Image.file(
                          _img!,
                          fit: BoxFit.cover,
                        )
                      : HiveDB.getUser().userImg != null
                          ? Image.network(
                              HiveDB.getUser().userImg!,
                              fit: BoxFit.cover,
                            )
                          : Image.asset("assets/images/img.png"),
                ),
                TextButton(
                  onPressed: _getPhoto,
                  child: const Text(
                    "Change profile photo",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                TextFieldEditProfile(
                  text: "Name",
                  controller: nameController,
                  errorShow: errorShow,
                ),
                TextFieldEditProfile(
                  text: "Username",
                  controller: userNameController,
                  errorShow: errorShow,
                ),
                const SizedBox(height: 10),
                TextFieldEditProfile(
                    text: "Bio",
                    controller: bioController,
                    errorShow: errorShow),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
