import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:proyecto_clase/data/datasources/remote/report_datasource.dart';
import 'package:proyecto_clase/domain/models/report.dart';
import 'user_datasource_test.mocks.dart';
import 'package:http/http.dart' as http;

void main() {
  late MockClient mockClient;
  late ReportDataSource reportDataSource;
  setUp(() {
    mockClient = MockClient();
    reportDataSource = ReportDataSource(client: mockClient);
  });
  const reportId = 9999;
  const getString = """
      [
        {
        "id": 10,
        "Report": "Example testing new QOL improvement",
        "Review": 5,
        "Revised": true,
        "Duration": 4,
        "clientName": "Dropbox",
        "start_time": "2024-05-15T13:05:00.000",
        "Support_User": 1714158128067
        }
      ]
      """;
  const String apiKey = 'aCpDCs';
  test("Testing Reports Datasource get", () async {
    final uri = Uri.parse("https://retoolapi.dev/$apiKey/data");
    when(mockClient.get(uri))
        .thenAnswer((_) async => http.Response(getString, 200));
    final result = await reportDataSource.getReports();
    expect(result, isList);
  });
  test("Testing Reports Datasource add", () async {
    final uri = Uri.parse("https://retoolapi.dev/$apiKey/data");
    Report report = Report(
        id: 10,
        report: "Example testing new QOL improvement",
        review: 5,
        revised: true,
        duration: 4,
        clientName: "Dropbox",
        startTime: "2024-05-15T13:05:00.000",
        supportUser: 1714158128067);
    when(mockClient.post(uri,
            headers: {"Content-Type": "application/json; charset=UTF-8"},
            body: jsonEncode(report.toJson())))
        .thenAnswer((_) async => http.Response("", 201));
    final result = await reportDataSource.addReport(report);
    expect(result, isTrue);
  });
  test("Testing Reports Datasource update", () async {
    final uri = Uri.parse("https://retoolapi.dev/$apiKey/data/$reportId");
    when(mockClient.patch(uri,
            headers: {"Content-Type": "application/json; charset=UTF-8"},
            body: jsonEncode({'Review': 3, 'Revised': true})))
        .thenAnswer((_) async => http.Response("", 200));
    final result = await reportDataSource.updateReport(reportId, 3);
    expect(result, isTrue);
  });
  test("Testing Reports Datasource getBySupportUser", () async {
    final uri = Uri.parse("https://retoolapi.dev/$apiKey/data");
    when(mockClient.get(uri))
        .thenAnswer((_) async => http.Response(getString, 200));
    final result =
        await reportDataSource.getReportsBySupportUser(1714158128067);
    expect(result, isList);
  });
}
