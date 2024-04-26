import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiServiceCoordinator {
  final String _baseUrl = 'https://retoolapi.dev/loA4Zo/client';

  Future<List<dynamic>> fetchClients() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load clients');
    }
  }

  Future<void> addClient(Map<String, dynamic> clientData) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(clientData),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to add client');
    }
  }

  Future<void> updateClient(String id, Map<String, dynamic> clientData) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(clientData),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update client');
    }
  }

  Future<void> deleteClient(String id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete client');
    }
  }
}
