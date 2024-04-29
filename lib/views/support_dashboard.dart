import 'package:flutter/material.dart';
import '../models/report.dart';
import '../services/api_service_reports.dart';

class SupportDashboard extends StatefulWidget {
  final String id;
  const SupportDashboard({super.key, required this.id});

  @override
  State<SupportDashboard> createState() => _SupportDashboardState();
}

class _SupportDashboardState extends State<SupportDashboard> {
  final ApiServiceReports apiService = ApiServiceReports();
  List<Report> reports = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchReports();
  }

  void fetchReports() async {
    try {
      List<Report> fetchedReports =
          await apiService.fetchReportsBySupportUser(int.parse(widget.id));
      setState(() {
        reports = fetchedReports;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching reports: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Support Dashboard - User ID: ${widget.id}"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            key: const Key('ButtonLogOut'),
            icon: Icon(Icons.exit_to_app),
            tooltip: 'Logout',
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context, '/', (route) => false),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: reports.length,
              itemBuilder: (context, index) {
                final report = reports[index];
                return ListTile(
                  title: Text(report.report),
                  subtitle: Text(
                      'Start Time: ${report.startTime}, Duration: ${report.duration} hours, Revised: ${report.revised}, Review: ${report.review}, Start Time: ${report.startTime}, Client: ${report.clientName}'),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => showAddReportDialog(context),
      ),
    );
  }

  void showAddReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        String reportDesc = '';
        String clientName = '';
        String startTime = '';
        String duration = '';
        return AlertDialog(
          title: Text('Create New Report'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) => reportDesc = value,
                decoration: InputDecoration(labelText: 'Problem Description'),
              ),
              TextField(
                onChanged: (value) => clientName = value,
                decoration: InputDecoration(labelText: 'Client Name'),
              ),
              TextField(
                onChanged: (value) => startTime = value,
                decoration: InputDecoration(labelText: 'Start Time (HH:MM)'),
              ),
              TextField(
                onChanged: (value) => duration = value,
                decoration: InputDecoration(labelText: 'Duration (in hours)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Report newReport = Report(
                  report: reportDesc,
                  review: 0,
                  revised: false,
                  duration: int.parse(duration),
                  startTime: startTime,
                  supportUser: int.parse(widget.id),
                  clientName: clientName,
                );
                bool isCreated = await apiService.createReport(newReport);
                Navigator.of(context).pop();
                if (isCreated) {
                  fetchReports(); // Refresh the list of reports
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Failed to create report")));
                }
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}