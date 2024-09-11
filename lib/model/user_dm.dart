class UserDM {
  static const collectionName = "users";
  static UserDM? currentUser;
  String userId;
  String email;
  String userName;

  UserDM({
    required this.userId,
    required this.email,
    required this.userName,
  });

  UserDM.fromJson(Map<String, dynamic> json)
      : userId = json['id'],
        email = json['email'],
        userName = json['userName'];

  Map<String, dynamic> toJson() {
    return {
      'id': userId,
      'email': email,
      'userName': userName,
    };
  }
}
