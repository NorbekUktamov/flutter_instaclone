class Post {
  late String id;
  late String postImage;
  late String caption;
  late String createDate;
  late bool isLiked;
  late bool isMine;

  Post({
    required this.id,
    required this.postImage,
    required this.caption,
    required this.createDate,
    required this.isLiked,
    required this.isMine,
  });

  Post.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        postImage = json["postImage"],
        caption = json["caption"],
        createDate = json["createDate"],
        isLiked = json["isLiked"],
        isMine = json["isMine"];

  Map<String, dynamic> toJson() => {
        "id": id,
        "postImage": postImage,
        "caption": caption,
        "createDate": createDate,
        "isLiked": isLiked,
        "isMine": isMine,
      };
}
