import 'dart:convert';
import 'package:http/http.dart' as http;
import 'userModel.dart';

class UserService {
  static const String baseUrl = 'http://192.168.44.1:4000/api'; // Replace with your backend URL

  Future<UserModel> fetchUserProfile(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/users/$userId'));

    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user profile');
    }
  }

  Future<void> updateUserProfile(UserModel user) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${user.userId}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update user profile');
    }
  }

   Future<int> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['user_id']; // Assuming the backend responds with user_id
    } else {
      throw Exception('Invalid email or password');
    }
  }

  Future<void> signup(String userName, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_name': userName,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Signup failed');
    }
  }
}
