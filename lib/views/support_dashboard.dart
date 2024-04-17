import 'package:flutter/material.dart';

class SupportDashboard extends StatefulWidget {
  @override
  _SupportDashboardState createState() => _SupportDashboardState();
}

class _SupportDashboardState extends State<SupportDashboard> {
  List<Report> reports = [
    Report('Report Example Client A', 'Client A', '12:00 PM', '1 hour', true, 4),
    Report('Report Example Client B', 'Client B', '10:00 AM', '2 hours', false, null),
    Report('Report Example Client C', 'Client C', '3:00 PM', '45 minutes', true, 3),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard Soporte"),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            tooltip: 'Logout',
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, '/', (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: reports.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(reports[index].problemDescription),
            subtitle: Text('Client: ${reports[index].clientName}, Start Time: ${reports[index].startTime}, Duration: ${reports[index].duration}'),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(reports[index].submitted ? Icons.check_circle_outline : Icons.error_outline, color: reports[index].submitted ? Colors.green : Colors.red),
                reports[index].grade != null ? Text('Grade: ${reports[index].grade}') : SizedBox.shrink(),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Create New Report'),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextField(
                        decoration: InputDecoration(labelText: 'Problem Description'),
                      ),
                      TextField(
                        decoration: InputDecoration(labelText: 'Client Name'),
                      ),
                      TextField(
                        decoration: InputDecoration(labelText: 'Start Time (HH:MM)'),
                      ),
                      TextField(
                        decoration: InputDecoration(labelText: 'Duration (in hours)'),
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Submit'),
                  ),
                ],
              );
            },
          );
        },
        tooltip: 'Create New Report',
        child: Icon(Icons.add),
      ),
    );
  }
}

class Report {
  final String problemDescription;
  final String clientName;
  final String startTime;
  final String duration;
  final bool submitted;
  final int? grade;

  Report(this.problemDescription, this.clientName, this.startTime, this.duration, this.submitted, this.grade);
}
