import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instaclone/theme/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_instaclone/models/post_model.dart';
import 'package:flutter_instaclone/pages/main_pages/my_home_page.dart';
import 'package:flutter_instaclone/services/storage_service.dart';
import '../../services/firestore_service.dart';
import '../../services/utils.dart';



class UploadPage extends StatefulWidget {
  static const String id = '/upload_page';
  PageController controller;
  UploadPage({Key? key, required this.controller}) : super(key: key);

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final TextEditingController _captionController = TextEditingController();
  final FocusNode _captionFocus = FocusNode();
  bool isLoading = false;
  File? _image;
  var selectedImageSize = '';


  // #camera
  _imageFromCamera() async {
    XFile? image = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = File(image!.path);
      selectedImageSize = _image != null ?(_image!.lengthSync() / 1024 / 1024).toStringAsFixed(2) + ' Mb' : '';
    });
  }

  // #gallery
  _imageFromGallery() async {
    XFile? image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = File(image!.path);
      selectedImageSize = _image != null ?(_image!.lengthSync() / 1024 / 1024).toStringAsFixed(2) + ' Mb' : '';
    });
  }

  // #gallery or camera
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
                    _imageFromCamera();
                    Navigator.of(context).pop();
                  },
                ),

                ListTile(
                  leading: const Icon(
                    Icons.camera_alt_rounded, color: Colors.red,),
                  title: const Text(
                    "Take Photo", style: TextStyle(color: Colors.white),),
                  onTap: () {
                    _imageFromGallery();
                    Navigator.of(context).pop();
                  },
                ),

              ],
            ),
          );
        }
    );
  }

  // #upload button
  void _uploadPost(){
    _captionFocus.unfocus();
    String caption = _captionController.text.toString().trim();
    if(_image == null && caption.isEmpty){
      Utils.snackBar(context, 'Attach a photo and make a caption, please!', ColorService.deepColor);
      return;
    }else if(_image == null){
      Utils.snackBar(context, 'Attach a photo, please!', ColorService.deepColor);
      return;
    } else if(caption.isEmpty){
      Utils.snackBar(context, 'Leave a caption, please!', ColorService.deepColor);
      return;
    }
    _postImage(caption);
  }

  void _postImage(String caption) {
    setState(() {
      isLoading = true;
    });
    StorageService.uploadPostImage(_image).then((downloadUrl) => {_resPostImage(caption, downloadUrl!)});
  }

  void _resPostImage(String caption, String downloadUrl) {
    Post post = Post(caption: caption, image: downloadUrl);
    _apiStorePost(post);
  }

  void _apiStorePost(Post post) async {
    Post posted = await FirestoreService.storePost(post);
    FirestoreService.storeFeed(posted).then((value) => {_moveToFeed()});
  }

  void _moveToFeed() {
    setState(() {
      isLoading = false;
      _image = null;
      _captionController.clear();
    });
    widget.controller.jumpToPage(0);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _captionController.dispose();
    _captionFocus.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    if(mounted){
      super.setState(fn);
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
              _image = null;
              _captionController.clear();
              _captionFocus.unfocus();
            });
            widget.controller.jumpToPage(0);
            Navigator.pushReplacementNamed(context, FeedPage.id);
          },
          icon: const Icon(Icons.home, color: Colors.red,),
        ),
        title: const Text("New post", style: TextStyle(color: Colors.white,fontFamily: 'Billabong',fontSize: 25),),
        actions: [
          IconButton(
            onPressed: _uploadPost,
            icon: const Icon(Icons.upload, color: Colors.red,),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 4,
            child: isLoading
                ? LinearProgressIndicator(color: Colors.yellow)
                : Container(),
          ),
          SizedBox(height: 2),
          Expanded(
            flex: 10,
            child: DottedBorder(
              strokeCap: StrokeCap.butt,
              dashPattern: const [10, 10, 10, 10],
              padding: EdgeInsets.all(_image != null ? 0 : 1),
              child: GestureDetector(
                onTap: _bottomSheet,
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                  ),
                  child: _image != null
                      ? Image.file(

                    _image!,
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
                controller: _captionController,
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 5,
                focusNode: _captionFocus,
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

