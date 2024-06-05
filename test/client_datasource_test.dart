import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:proyecto_clase/data/datasources/remote/client_datasource.dart';
import 'package:proyecto_clase/domain/models/client.dart';
import 'user_datasource_test.mocks.dart';
import 'package:http/http.dart' as http;

void main() {
  late MockClient mockClient;
  late ClientDataSource clientDataSource;
  setUp(() {
    mockClient = MockClient();
    clientDataSource = ClientDataSource(client: mockClient);
  });
  const clientId = 999;
  const getString = """
      [
      {
        "id": 1,
        "name": "General Motors"
      },
      {
        "id": 2,
        "name": "General Electric"
      }
      ]
      """;
  const String apiKey = 'loA4Zo';
  test("Testing Client Datasource get", () async {
    final uri = Uri.parse("https://retoolapi.dev/$apiKey/client")
        .resolveUri(Uri(queryParameters: {
      "format": 'json',
    }));
    when(mockClient.get(uri))
        .thenAnswer((_) async => http.Response(getString, 200));
    final result = await clientDataSource.getClients();
    expect(result, isList);
  });
  test("Testing Client Datasource add", () async {
    final uri = Uri.parse("https://retoolapi.dev/$apiKey/client");
    Client client = Client(id: "10", name: "Xiaomi");
    when(mockClient.post(uri,
            headers: {"Content-Type": "application/json; charset=UTF-8"},
            body: jsonEncode(client.toJson())))
        .thenAnswer((_) async => http.Response("", 201));
    final result = await clientDataSource.addClient(client);
    expect(result, isTrue);
  });
  test("Testing Client Datasource update", () async {
    final uri = Uri.parse("https://retoolapi.dev/$apiKey/client/$clientId");
    Client client = Client(id: clientId.toString(), name: "Xiaomi");
    when(mockClient.put(uri,
            headers: {"Content-Type": "application/json; charset=UTF-8"},
            body: jsonEncode(client.toJson())))
        .thenAnswer((_) async => http.Response("", 200));
    final result = await clientDataSource.updateClient(client);
    expect(result, isTrue);
  });
  test("Testing Client Datasource delete", () async {
    final uri = Uri.parse("https://retoolapi.dev/$apiKey/client/$clientId");
    when(mockClient.delete(uri, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    })).thenAnswer((_) async => http.Response(getString, 200));
    final result = await clientDataSource.deleteClient(clientId);
    expect(result, isTrue);
  });
}
