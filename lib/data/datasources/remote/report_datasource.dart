import 'dart:convert';
import 'package:loggy/loggy.dart';
import '../../../domain/models/report.dart';
import 'package:http/http.dart' as http;

import 'i_report_datasource.dart';

class ReportDataSource implements IReportDataSource {
  final http.Client httpClient;
  final String apiKey = 'aCpDCs';

  ReportDataSource({http.Client? client}) : httpClient = client ?? http.Client();

  @override
  Future<List<Report>> getReports() async {
    try {
      var response = await httpClient.get(Uri.parse("https://retoolapi.dev/$apiKey/data"));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        return data.map((item) => Report.fromJson(item)).toList();
      } else {
        logError("Failed to fetch reports: ${response.statusCode}");
        throw Exception('Failed to fetch reports');
      }
    } catch (e) {
      logError("Error occurred: $e");
      throw Exception('Error fetching reports');
    }
  }

   @override
  Future<List<Report>> getReportsBySupportUser(int supportUserId) async {
    try {
      List<Report> allReports = await getReports();
      return allReports.where((report) => report.supportUser == supportUserId).toList();
    } catch (e) {
      logError("Error filtering reports for user $supportUserId: $e");
      throw Exception('Failed to filter reports for support user $supportUserId: $e');
    }
  }

  @override
  Future<bool> addReport(Report report) async {
    try {
      var response = await httpClient.post(
        Uri.parse("https://retoolapi.dev/$apiKey/data"),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(report.toJson()),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        logError("Failed to create report: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      logError("Error occurred: $e");
      return false;
    }
  }

  @override
  Future<bool> updateReport(int reportId, int reviewScore) async {
    try {
      var response = await httpClient.patch(
        Uri.parse("https://retoolapi.dev/$apiKey/data/$reportId"),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'Review': reviewScore, 'Revised': true}),
      );

      if (response.statusCode == 200) {
        logInfo("Report updated successfully");
        return true;
      } else {
        logError("Failed to update report: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      logError("Error occurred: $e");
      return false;
    }
  }
}
