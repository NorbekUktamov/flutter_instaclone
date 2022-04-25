import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;

class StorageService {
  static final storage = FirebaseStorage.instance.ref();
  static const String folderUserImg = "user_image";
  static const String folderPostImg = "post_image";

  static Future<String?> uploadImg(File? _image, String folder, {String? oldUrl}) async {
    if (oldUrl != null) {
      await deleteStorage(oldUrl, folder);
    }
    String? url;
    String _imgName = "image_" + DateTime.now().toString();
    Reference fireBaseStorageRef = storage.child(folder).child(_imgName);
    if (_image != null) {
      await fireBaseStorageRef.putFile(_image).then((p0) async {
        final String downloadImg = await p0.ref.getDownloadURL();
        url = downloadImg;
      });
    }
    return url;
  }

  static deleteStorage(String oldUrl, folder) async {
    var fileUrl = Uri.decodeFull(Path.basename(oldUrl))
        .replaceAll(RegExp(r'(\?alt).*'), '');
    var fileUrlNew = Uri.decodeFull(Path.basename(fileUrl))
        .replaceAll(RegExp(r'post_image/'), '');
    Reference photoRef = storage.child(folder).child(fileUrlNew);
    try {
      await photoRef.delete();
    } catch (e) {}
  }
}
