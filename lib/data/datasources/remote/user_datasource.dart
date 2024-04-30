import 'dart:convert';
import 'package:loggy/loggy.dart';
import 'package:proyecto_clase/domain/models/user_support.dart';
import 'package:http/http.dart' as http;

import 'i_user_datasource.dart';

class UserDataSource implements IUserDataSource {
  final http.Client httpClient;
  final String apiKey = '0qmY4G';

  UserDataSource({http.Client? client}) : httpClient = client ?? http.Client();

  @override
  Future<List<UserSupport>> getUsers() async {
    List<UserSupport> users = [];
    var request = Uri.parse("https://retoolapi.dev/$apiKey/user_support")
        .resolveUri(Uri(queryParameters: {
      "format": 'json',
    }));

    var response = await httpClient.get(request);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      users = List<UserSupport>.from(data.map((x) => UserSupport.fromJson(x)));
    } else {
      logError("Got error code ${response.statusCode}");
      return Future.error('Error code ${response.statusCode}');
    }

    return Future.value(users);
  }

  @override
  Future<bool> addUser(UserSupport user) async {
    logInfo("Web service, Adding user");

    final response = await httpClient.post(
      Uri.parse("https://retoolapi.dev/$apiKey/user_support"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 201) {
      //logInfo(response.body);
      return Future.value(true);
    } else {
      logError("Got error code ${response.statusCode}");
      return Future.value(false);
    }
  }

  @override
  Future<bool> updateUser(UserSupport user) async {
    final response = await httpClient.put(
      Uri.parse("https://retoolapi.dev/$apiKey/user_support/${user.id}"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200) {
      return Future.value(true);
    } else {
      logError("Got error code ${response.statusCode}");
      return Future.value(false);
    }
  }

  @override
  Future<bool> deleteUser(int id) async {
    final response = await httpClient.delete(
      Uri.parse("https://retoolapi.dev/$apiKey/user_support/$id"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    logInfo("Deleting user with id $id status code ${response.statusCode}");
    if (response.statusCode == 200) {
      //logInfo(response.body);
      return Future.value(true);
    } else {
      logError("Got error code ${response.statusCode}");
      return Future.value(false);
    }
  }
  
  @override
  Future<UserSupport?> findUserByEmail(String email) async {
    final response = await httpClient.get(
      Uri.parse("https://retoolapi.dev/$apiKey/user_support"),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      final userJson = data.firstWhere(
        (u) => u['email'] == email,
        orElse: () => null,
      );
      return userJson != null ? UserSupport.fromJson(userJson) : null;
    } else {
      logError("Error fetching users: ${response.statusCode}");
      return null;
    }
  }

  @override
  Future<UserSupport?> validateCredentials(String email, String password) async {
    final response = await httpClient.get(
      Uri.parse("https://retoolapi.dev/$apiKey/user_support"),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      final userJson = data.firstWhere(
        (u) => u['email'] == email && u['password'] == password,
        orElse: () => null,
      );
      return userJson != null ? UserSupport.fromJson(userJson) : null;
    } else {
      logError("Error fetching users: ${response.statusCode}");
      return null;
    }
  }
}