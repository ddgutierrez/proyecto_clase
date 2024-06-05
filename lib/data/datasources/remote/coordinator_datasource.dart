import 'dart:convert';
import 'package:loggy/loggy.dart';
import 'package:proyecto_clase/domain/models/coordinator.dart';
import 'package:http/http.dart' as http;

import 'i_coordinator_datasource.dart';

class CoordinatorDatasource implements ICoordinatorDataSource {
  final http.Client httpClient;
  final String apiKey = 'dTW0Tl';

  CoordinatorDatasource({http.Client? client}) : httpClient = client ?? http.Client();
  @override
  Future<Coordinator?> validateCredentials(String email, String password) async {
    final response = await httpClient.get(
      Uri.parse("https://retoolapi.dev/$apiKey/coordinators"),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      final userJson = data.firstWhere(
        (u) => u['email'] == email && u['password'] == password,
        orElse: () => null,
      );
      return userJson != null ? Coordinator.fromJson(userJson) : null;
    } else {
      logError("Error fetching users: ${response.statusCode}");
      return null;
    }
  }
}