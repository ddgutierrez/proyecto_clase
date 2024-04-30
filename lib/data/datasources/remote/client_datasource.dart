import 'dart:convert';
import 'package:loggy/loggy.dart';
import '../../../domain/models/client.dart'; 
import 'package:http/http.dart' as http;

import 'i_client_datasource.dart'; 
class ClientDataSource implements IClientDataSource {
  final http.Client httpClient;
  final String apiKey = 'loA4Zo';

  ClientDataSource({http.Client? client}) : httpClient = client ?? http.Client();

  @override
  Future<List<Client>> getClients() async {
    List<Client> clients = [];
    var request = Uri.parse("https://retoolapi.dev/$apiKey/client")
        .resolveUri(Uri(queryParameters: {
      "format": 'json',
    }));

    var response = await httpClient.get(request);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      clients = List<Client>.from(data.map((x) => Client.fromJson(x)));
    } else {
      logError("Got error code ${response.statusCode}");
      return Future.error('Error code ${response.statusCode}');
    }

    return clients;
  }

  @override
  Future<bool> addClient(Client client) async {
    final response = await httpClient.post(
      Uri.parse("https://retoolapi.dev/$apiKey/client"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(client.toJson()),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      logError("Got error code ${response.statusCode}");
      return false;
    }
  }

  @override
  Future<bool> updateClient(Client client) async {
    final response = await httpClient.put(
      Uri.parse("https://retoolapi.dev/$apiKey/client/${client.id}"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(client.toJson()),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      logError("Got error code ${response.statusCode}");
      return false;
    }
  }

  @override
  Future<bool> deleteClient(int id) async {
    final response = await httpClient.delete(
      Uri.parse("https://retoolapi.dev/$apiKey/client/$id"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      logError("Got error code ${response.statusCode}");
      return false;
    }
  }
}
