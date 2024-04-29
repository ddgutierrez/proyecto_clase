import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proyecto_clase/models/client.dart';

class ApiServiceCoordinator {
  final String _baseUrl = 'https://retoolapi.dev/loA4Zo/client';

  // Corrected the JSON parsing and handling of response for fetching clients
  Future<List<Client>> fetchClients() async {
    final response = await http.get(Uri.parse(_baseUrl), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      List<dynamic> json = jsonDecode(response.body);
      return json.map((data) => Client.fromJson(data)).toList(); // Ensure your Client model has a fromJson method
    } else {
      throw Exception('Failed to load clients');
    }
  }

  // Corrected how you're encoding data to JSON for adding a client
  Future<void> addClient(String name) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name}), // Assuming your API expects a JSON object with a "name" field
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to add client');
    }
  }

  // Corrected how you're encoding data to JSON for updating a client
  Future<void> updateClient(String id, String name) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name}), // Correct JSON encoding, only pass the necessary fields
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update client');
    }
  }

  // Proper implementation for deleting a client
  Future<void> deleteClient(String id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/$id'), headers: {'Content-Type': 'application/json'});
    if (response.statusCode != 200) {
      throw Exception('Failed to delete client');
    }
  }
}
