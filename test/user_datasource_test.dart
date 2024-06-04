import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:proyecto_clase/data/datasources/remote/user_datasource.dart';

import 'user_datasource_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late MockClient mockClient;
  late UserDataSource userDataSource;

  setUp(() {
    mockClient = MockClient();
    userDataSource = UserDataSource(client: mockClient);
  });
  const jsonString = """
      [
        {
        "id": 999,
        "name": "name",
        "email": "email@example.com",
        "password": "guessthepassword"
        }
      ]
      """;
  test("Testing Users Datasource", () async {
    const String apiKey = '0qmY4G';
    final uri = Uri.parse("https://retoolapi.dev/$apiKey/user_support")
        .resolveUri(Uri(queryParameters: {
      "format": 'json',
    }));
    when(mockClient.get(uri))
        .thenAnswer((_) async => http.Response(jsonString, 200));
    final result = await userDataSource.getUsers();
    expect(result, isList);
  });
}
