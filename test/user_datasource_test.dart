import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:proyecto_clase/data/datasources/remote/user_datasource.dart';
import 'package:proyecto_clase/domain/models/user_support.dart';

import 'user_datasource_test.mocks.dart';

@GenerateNiceMocks([MockSpec<http.Client>()])
void main() {
  late MockClient mockClient;
  late UserDataSource userDataSource;

  setUp(() {
    mockClient = MockClient();
    userDataSource = UserDataSource(client: mockClient);
  });
  const id = 9999;
  const getString = """
      [
        {
        "id": 999,
        "name": "name",
        "email": "email@example.com",
        "password": "guessthepassword"
        }
      ]
      """;
  const String apiKey = '0qmY4G';
  test("Testing Users Datasource get", () async {
    final uri = Uri.parse("https://retoolapi.dev/$apiKey/user_support")
        .resolveUri(Uri(queryParameters: {
      "format": 'json',
    }));
    when(mockClient.get(uri))
        .thenAnswer((_) async => http.Response(getString, 200));
    final result = await userDataSource.getUsers();
    expect(result, isList);
  });
  test("Testing Users Datasource add", () async {
    final uri = Uri.parse("https://retoolapi.dev/$apiKey/user_support");
    UserSupport userSupport = UserSupport(
        id: "9999", name: "foo", email: "foo@mail.com", password: "852852");
    when(mockClient.post(uri,
            headers: {"Content-Type": "application/json; charset=UTF-8"},
            body: jsonEncode(userSupport.toJson())))
        .thenAnswer((_) async => http.Response("", 201));
    final result = await userDataSource.addUser(userSupport);
    expect(result, isTrue);
  });
  test("Testing Users Datasource update", () async {
    final uri = Uri.parse("https://retoolapi.dev/$apiKey/user_support/$id");
    UserSupport userSupport = UserSupport(
        id: id.toString(),
        name: "foo",
        email: "foo@mail.com",
        password: "852852");
    when(mockClient.put(uri,
            headers: {"Content-Type": "application/json; charset=UTF-8"},
            body: jsonEncode(userSupport.toJson())))
        .thenAnswer((_) async => http.Response("", 200));
    final result = await userDataSource.updateUser(userSupport);
    expect(result, isTrue);
  });
  test("Testing Users Datasource delete", () async {
    final uri = Uri.parse("https://retoolapi.dev/$apiKey/user_support/$id");
    when(mockClient.delete(
      uri,
      headers: {"Content-Type": "application/json; charset=UTF-8"},
    )).thenAnswer((_) async => http.Response("", 200));
    final result = await userDataSource.deleteUser(id);
    expect(result, isTrue);
  });
}
