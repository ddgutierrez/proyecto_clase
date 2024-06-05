import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:proyecto_clase/data/datasources/remote/coordinator_datasource.dart';
import 'package:proyecto_clase/domain/models/coordinator.dart';
import 'user_datasource_test.mocks.dart';
import 'package:http/http.dart' as http;

void main() {
  late MockClient mockClient;
  late CoordinatorDatasource coordinatorDataSource;
  setUp(() {
    mockClient = MockClient();
    coordinatorDataSource = CoordinatorDatasource(client: mockClient);
  });
  const getString = """
      [
      {
        "id": 1,
        "email": "a@a.com",
        "password": "passwordA"
      },
      {
        "id": 2,
        "email": "b@a.com",
        "password": "passwordB"
      }
      ]
      """;
  const String apiKey = 'dTW0Tl';
  test("Testing Coordinator Datasource validateCredentials", () async {
    final uri = Uri.parse("https://retoolapi.dev/$apiKey/coordinators");
    when(mockClient.get(uri, headers: {'Content-Type': 'application/json'}))
        .thenAnswer((_) async => http.Response(getString, 200));
    final result =
        await coordinatorDataSource.validateCredentials("a@a.com", "passwordA");
    expect(result, isInstanceOf<Coordinator>());
  });
}
