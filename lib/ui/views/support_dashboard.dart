import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/models/report.dart';
import '../controllers/report_controller.dart';

class SupportDashboard extends StatelessWidget {
  final String id;
  const SupportDashboard({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ReportController controller = Get.find();
    controller.getReportsBySupportUser(int.parse(id));

    return Scaffold(
      appBar: AppBar(
        title: Text("Support Dashboard - User ID: $id"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            key: const Key('ButtonLogOut'),
            icon: const Icon(Icons.exit_to_app),
            tooltip: 'Logout',
            onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.reports.isEmpty) {
          return const Center(child: Text('No reports available for review.'));
        } else {
          return ListView.builder(
            itemCount: controller.reports.length,
            itemBuilder: (context, index) {
              final report = controller.reports[index];
              return ListTile(
                title: Text(report.report),
                subtitle: Text('Start Time: ${report.startTime}, Duration: ${report.duration} hours, Revised: ${report.revised}, Review: ${report.review}, Client: ${report.clientName}'),
              );
            },
          );
        }
      }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => showAddReportDialog(context, controller, int.parse(id)),
      ),
    );
  }
    void showAddReportDialog(BuildContext context, ReportController controller, int userId) {
    showDialog(
      context: context,
      builder: (context) {
        String reportDesc = '', clientName = '', startTime = '', duration = '';
        return AlertDialog(
          title: const Text('Create New Report'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(onChanged: (value) => reportDesc = value, decoration: const InputDecoration(labelText: 'Descripcion del informe')),
              TextField(onChanged: (value) => clientName = value, decoration: const InputDecoration(labelText: 'Nombre del cliente')),
              TextField(onChanged: (value) => startTime = value, decoration: const InputDecoration(labelText: 'Hora de inicio (HH:MM)')),
              TextField(onChanged: (value) => duration = value, decoration: const InputDecoration(labelText: 'Tiempo de duracion (horas)')),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (reportDesc.isNotEmpty && clientName.isNotEmpty && startTime.isNotEmpty && duration.isNotEmpty) {
                  Report newReport = Report(
                    report: reportDesc,
                    review: 0,
                    revised: false,
                    duration: int.parse(duration),
                    startTime: startTime,
                    supportUser: userId,
                    clientName: clientName,
                  );
                  bool isCreated = await controller.createReport(newReport);
                  Navigator.of(context).pop();
                  if (!isCreated) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to create report")));
                  }
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}
