class UserModel {
  final int userId;
  String userName;
  String email;
  String? password;
  String? profilePicture;

  UserModel({
    required this.userId,
    required this.userName,
    required this.email,
    this.password,
    this.profilePicture,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id'],
      userName: json['user_name'],
      email: json['email'],
      profilePicture: json['profile_picture'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'user_name': userName,
      'email': email,
      'password': password,
      'profile_picture': profilePicture,
    };
  }
}
