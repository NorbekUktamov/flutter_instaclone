import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instaclone/theme/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_instaclone/models/post_model.dart';
import 'package:flutter_instaclone/pages/main_pages/my_home_page.dart';
import 'package:flutter_instaclone/services/data_service.dart';
import 'package:flutter_instaclone/services/hive_db_service.dart';
import 'package:flutter_instaclone/services/storage_service.dart';
import 'package:logger/logger.dart';
import '../../widgets/splash_page_widgets.dart';
import 'home_page.dart';

class MyPostPage extends StatefulWidget {
  PageController controller;
   MyPostPage({Key? key, required this.controller}) : super(key: key);
  static String id = "/my_post_page";


  @override
  State<MyPostPage> createState() => _MyPostPageState();
}

class _MyPostPageState extends State<MyPostPage> {
  bool load = false;
  File? image;
  final picker = ImagePicker();
  FocusNode focusNode = FocusNode();
  TextEditingController textController = TextEditingController();

  getImageGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      } else {
        Logger().e("No image selected!");
      }
    });
  }

  getImageCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      } else {
        Logger().e("No image selected!");
      }
    });
  }

  _bottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: 120,
            color: Colors.black,
            child: Column(
              children: [

                ListTile(
                  leading: const Icon(Icons.photo_library, color: Colors.red,),
                  title: const Text(
                    "Pick Photo", style: TextStyle(color: Colors.white),),
                  onTap: () {
                    getImageCamera();
                    Navigator.of(context).pop();
                  },
                ),

                ListTile(
                  leading: const Icon(
                    Icons.camera_alt_rounded, color: Colors.red,),
                  title: const Text(
                    "Take Photo", style: TextStyle(color: Colors.white),),
                  onTap: () {
                    getImageGallery();
                    Navigator.of(context).pop();
                  },
                ),

              ],
            ),
          );
        }
    );
  }

  _savePost() async {
    Logger().i(image.toString() + textController.text.trim());
    if (image == null || textController.text
        .trim()
        .isEmpty) {
      return;
    }
    setState(() {
      load = true;
    });
    await StorageService.uploadImg(image, DataService.postFolder)
        .then((value) => _putPost(value));
  }

  _putPost(String? img) async {
    if (img != null) {
      DataService.putPost(Post(
        id: HiveDB
            .getUser()
            .id,
        postImage: img,
        caption: textController.text,
        createDate: DateTime.now().toString(),
        isLiked: false,
        isMine: true,
      )).then((value) {
        setState(() {
          load = false;
        });
        Navigator.pushReplacementNamed(context, HomePage.id);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            setState(() {
              image = null;
              textController.clear();
              focusNode.unfocus();
            });
            widget.controller.jumpToPage(0);
            Navigator.pushReplacementNamed(context, HomePage.id);
          },
          icon: const Icon(Icons.home, color: Colors.red,),
        ),
        title: const Text("New post", style: TextStyle(color: Colors.white),),
        actions: [
          IconButton(
            onPressed: _savePost,
            icon: const Icon(Icons.upload, color: Colors.red,),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 4,
            child: load
                ? LinearProgressIndicator(color: Colors.yellow)
                : Container(),
          ),
          SizedBox(height: 2),
          Expanded(
            flex: 10,
            child: DottedBorder(
              strokeCap: StrokeCap.butt,
              dashPattern: const [10, 10, 10, 10],
              padding: EdgeInsets.all(image != null ? 0 : 1),
              child: GestureDetector(
                onTap: _bottomSheet,
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                  ),
                  child: image != null
                      ? Image.file(
                    image!,
                    fit: BoxFit.cover,
                  )
                      : Icon(
                    CupertinoIcons.camera,
                    size: MediaQuery
                        .of(context)
                        .size
                        .width * 0.1,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            flex: 9,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                controller: textController,
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 5,
                focusNode: focusNode,
                decoration: const InputDecoration(
                  hintText: "Caption",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 2.0),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
