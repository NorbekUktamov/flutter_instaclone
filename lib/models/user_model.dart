class UserModel {
  late String id;
  late String fullName;
  late String userName;
  late String email;
  late String password;
  String? userImg;
  bool isFollowing = false;
  int followersCount = 0;
  int followingCount = 0;

  // List<dynamic>? post;

  UserModel({
    required this.id,
    required this.fullName,
    required this.userName,
    required this.email,
    required this.password,
    this.userImg,
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        fullName = json["fullName"],
        userName = json["userName"],
        userImg = json["userImg"],
        email = json['email'],
        password = json['password'];

  Map<String, dynamic> toJson() => {
        "id": id,
        "fullName": fullName,
        "userName": userName,
        "userImg": userImg,
        "email": email,
        "password": password,
      };

  @override
  bool operator ==(Object other) {
    return other is UserModel && other.id == id;
  }

  @override
  int get hashCode => super.hashCode;

}


