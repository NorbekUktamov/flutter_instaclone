class UserModel {
  String? uid;
  String? profileImageURL;
  String username;
  String fullname;
  String email;
  String password;


  bool isFollowed = false;
  int followers = 0;
  int followings = 0;

  // #for notification
  String deviceId = "";
  String deviceType = "";
  String deviceToken = "";

  UserModel(
      {required this.password, required this.username,required this.fullname, required this.email});

  UserModel.fromJson(Map<String, dynamic> json)
      : uid = json["uid"],
        username = json["username"],
        fullname=json["fullname"],
        email = json["email"],
        password = json["password"],
        profileImageURL = json["profileImageURL"],
        followers = json["followers"],
        followings = json["followings"],
        deviceId = json['device_id'] ?? "",
        deviceType = json['device_type'] ?? "",
        deviceToken = json['device_token'] ?? "";

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "username": username,
    "fullname": fullname,
    "email": email,
    "password": password,
    "profileImageURL": profileImageURL,
    "followers": followers,
    "followings": followings,
    'device_id': deviceId,
    'device_type': deviceType,
    'device_token': deviceToken,
  };

  @override
  bool operator ==(Object other) {
    return other is UserModel && other.uid == uid;
  }

  @override
  int get hashCode => uid.hashCode;
}
