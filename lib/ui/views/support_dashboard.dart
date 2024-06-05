import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Add this import
import 'package:proyecto_clase/ui/controllers/connectivity_controller.dart';
import '../../domain/models/report.dart';
import '../controllers/report_controller.dart';
import '../controllers/client_controller.dart';

class SupportDashboard extends StatelessWidget {
  final String id;
  const SupportDashboard({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ReportController reportController = Get.find<ReportController>();
    final ClientController clientController = Get.find<ClientController>();
    ConnectivityController connectivityController = Get.find();
    reportController.getReportsBySupportUser(int.parse(id));
    clientController.getClients(); // Ensure clients are fetched

    return Scaffold(
      appBar: AppBar(
        title: Text("Support Dashboard - User ID: $id"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            key: const Key('ButtonLogOut'),
            icon: const Icon(Icons.exit_to_app),
            tooltip: 'Logout',
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context, '/', (route) => false),
          ),
        ],
      ),
      body: Obx(() {
        if (reportController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (reportController.reports.isEmpty) {
          return const Center(child: Text('No reports available for review.'));
        } else {
          return ListView.builder(
            itemCount: reportController.reports.length,
            itemBuilder: (context, index) {
              final report = reportController.reports[index];
              final formattedDateTime = DateFormat('yyyy-MM-dd – kk:mm').format(
                  DateTime.parse(report.startTime)); // Format the date and time
              return ListTile(
                title: Text(report.report),
                subtitle: Text(
                    'Start Time: $formattedDateTime, Duration: ${report.duration} hours, Revised: ${report.revised}, Review: ${report.review}, Client: ${report.clientName}'),
              );
            },
          );
        }
      }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          if (!connectivityController.connection) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Modo Offline"),
              elevation: 10,
            ));
          }
          showAddReportDialog(
              context, reportController, clientController, int.parse(id));
        },
      ),
    );
  }

  void showAddReportDialog(
      BuildContext context,
      ReportController reportController,
      ClientController clientController,
      int userId) {
    showDialog(
      context: context,
      builder: (context) {
        final _formKey = GlobalKey<FormState>();
        String reportDesc = '';
        String? clientName; // Ensure clientName is nullable
        DateTime? selectedDateTime;
        String duration = '';

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Crear Nuevo Reporte'),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      onChanged: (value) => reportDesc = value,
                      decoration: const InputDecoration(
                          labelText: 'Descripcion del informe'),
                      validator: (value) =>
                          value!.isEmpty ? 'Campo Requerido' : null,
                    ),
                    Obx(() {
                      if (clientController.clients.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        return DropdownButtonFormField<String>(
                          value: clientName,
                          items: clientController.clients.map((client) {
                            return DropdownMenuItem<String>(
                              value: client.name,
                              child: Text(client.name),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              clientName = value;
                            });
                          },
                          decoration: const InputDecoration(
                              labelText: 'Nombre del cliente'),
                          validator: (value) =>
                              value == null ? 'Campo Requerido' : null,
                        );
                      }
                    }),
                    TextFormField(
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (pickedTime != null) {
                            setState(() {
                              selectedDateTime = DateTime(
                                pickedDate.year,
                                pickedDate.month,
                                pickedDate.day,
                                pickedTime.hour,
                                pickedTime.minute,
                              );
                            });
                          }
                        }
                      },
                      decoration: InputDecoration(
                        labelText: selectedDateTime == null
                            ? 'Fecha y hora de inicio'
                            : 'Fecha y hora de inicio: ${DateFormat('yyyy-MM-dd – kk:mm').format(selectedDateTime!)}',
                      ),
                      validator: (value) =>
                          selectedDateTime == null ? 'Campo Requerido' : null,
                    ),
                    TextFormField(
                      onChanged: (value) => duration = value,
                      decoration: const InputDecoration(
                          labelText: 'Tiempo de duracion (horas)'),
                      validator: (value) =>
                          value!.isEmpty ? 'Campo Requerido' : null,
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      String formattedDateTime =
                          selectedDateTime!.toIso8601String();
                      Report newReport = Report(
                        report: reportDesc,
                        review: 0,
                        revised: false,
                        duration: int.parse(duration),
                        startTime: formattedDateTime,
                        supportUser: userId,
                        clientName: clientName!,
                      );
                      bool isCreated =
                          await reportController.createReport(newReport);
                      Get.back();
                      if (!isCreated) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Error al crear reporte")));
                      } else {
                        reportController.getReportsBySupportUser(
                            userId); // Fetch reports only for the specific support user
                      }
                    }
                  },
                  child: const Text('Enviar'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
