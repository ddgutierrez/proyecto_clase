import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_support.dart';

class ApiService {
  static const String _baseUrl = 'https://retoolapi.dev/0qmY4G/user_support';

  Future<List<UserSupport>> fetchSupportUsers() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => UserSupport.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load support users');
    }
  }

  Future<void> addSupportUser(UserSupport user) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'id': user.id,
        'name': user.name,
        'email': user.email,
        'password': user.password,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add user');
    }
  }

  Future<void> updateSupportUser(
      String id, Map<String, dynamic> userData) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/$id'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(userData),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update user');
    }
  }

  Future<void> deleteSupportUser(String id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete user');
    }
  }

  Future<bool> emailExists(String email) async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<UserSupport> users =
          data.map((item) => UserSupport.fromJson(item)).toList();
      return users.any((user) => user.email == email);
    } else {
      throw Exception('Failed to check email existence');
    }
  }
}
