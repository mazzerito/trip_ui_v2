class User {
  final int? userId;
  final String userName;
  final String? userEmail;


  User({
    this.userId,
    required this.userName,
    required this.userEmail,

  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'],
      userName: json['user_name'],
      userEmail: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'user_name': userName,
      'email': userEmail,
    };
  }
}
