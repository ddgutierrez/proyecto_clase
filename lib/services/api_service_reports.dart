import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/report.dart';

class ApiServiceReports {
  final String baseUrl = 'https://retoolapi.dev/o5TFyJ/data';

  // Function to create a new report
  Future<void> createReport(Report report) async {
    try {
      var response = await http.post(
        Uri.parse(baseUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(report.toJson()),
      );

      if (response.statusCode == 201) {
        print('Report created successfully');
      } else {
        print('Failed to create report: ${response.body}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  // Function for coordinators to review a report
  Future<void> reviewReport(int reportId, int reviewScore) async {
    try {
      var response = await http.patch(
        Uri.parse('$baseUrl/$reportId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'Review': reviewScore,
          'Revised': true,
        }),
      );

      if (response.statusCode == 200) {
        print('Report reviewed successfully');
      } else {
        print('Failed to review report: ${response.body}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  Future<List<Report>> fetchReports() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        return data.map((item) => Report.fromJson(item)).toList();
      } else {
        print('Failed to fetch reports: ${response.body}');
        return []; // Return empty list on error
      }
    } catch (e) {
      print('Error occurred: $e');
      return []; // Return empty list on error
    }
  }
}
