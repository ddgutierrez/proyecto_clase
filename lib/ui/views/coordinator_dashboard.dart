import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import '../../domain/models/user_support.dart';
import '../../domain/models/report.dart';
import '../../domain/models/client.dart';
import '../controllers/support_controller.dart';
import '../controllers/client_controller.dart';
import '../controllers/report_controller.dart';

class CoordinatorDashboard extends StatefulWidget {
  const CoordinatorDashboard({super.key});
  @override
  State<CoordinatorDashboard> createState() => _DashboardState();
}

class _DashboardState extends State<CoordinatorDashboard> {
  Widget layout({required int index}) {
    switch (index) {
      case 0:
        {
          return const ClientManagement();
        }
      case 1:
        {
          return const UserSupportManagement();
        }
      case 2:
        {
          return WorkReportEvaluation();
        }
      case 3:
        {
          return const ReportManagement();
        }
      case 4:
        {
          return SupportUserStats();
        }
      default:
        {
          return const ClientManagement();
        }
    }
  }

  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Coordinador"),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            key: const Key('ButtonLogOut'),
            icon: const Icon(Icons.exit_to_app),
            tooltip: 'Logout',
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/', (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
      body: Row(
        children: [
          NavigationRail(
            extended: MediaQuery.sizeOf(context).width > 500,
            backgroundColor: Colors.grey.withOpacity(0.5),
            destinations: const [
              NavigationRailDestination(
                  icon: Icon(Icons.account_box),
                  label: Text('Aministrar Clientes')),
              NavigationRailDestination(
                  icon: Icon(Icons.support_agent),
                  label: Text('Administrar Usuarios\nde Soporte')),
              NavigationRailDestination(
                  icon: Icon(Icons.rate_review),
                  label: Text('Evaluar Reportes')),
              NavigationRailDestination(
                  icon: Icon(Icons.report),
                  label: Text('Administrar Reportes')),
              NavigationRailDestination(
                  icon: Icon(Icons.assessment),
                  label: Text('Estadisticas de Usuarios\nde Soporte'))
            ],
            selectedIndex: _selectedIndex,
            onDestinationSelected: (value) => setState(() {
              _selectedIndex = value;
            }),
          ),
          Expanded(child: layout(index: _selectedIndex))
        ],
      ),
    );
  }
}

class UserSupportManagement extends StatefulWidget {
  const UserSupportManagement({Key? key}) : super(key: key);

  @override
  _UserSupportManagementState createState() => _UserSupportManagementState();
}

class _UserSupportManagementState extends State<UserSupportManagement> {
  final TextEditingController addNameController = TextEditingController();
  final TextEditingController addEmailController = TextEditingController();
  final TextEditingController addPasswordController = TextEditingController();

  final SupportController supportController = Get.find<SupportController>();

  @override
  void initState() {
    super.initState();
    supportController.getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView(
          padding: const EdgeInsets.all(8.0),
          children: [
            ExpansionTile(
              title: const Text('Add User',
                  style: TextStyle(color: Colors.deepPurple)),
              children: [
                buildTextField(addNameController, 'Nombre'),
                buildTextField(addEmailController, 'Email'),
                buildTextField(addPasswordController, 'Contraseña',
                    isPassword: true),
                ElevatedButton(
                  onPressed: addSupportUser,
                  child: const Text('Crear Usuario de Soporte'),
                ),
              ],
            ),
            for (var user in supportController.users)
              ListTile(
                title: Text(user.name),
                subtitle: Text(user.email),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => showEditDialog(context, user),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () =>
                          supportController.deleteUser(int.parse(user.id)),
                    ),
                  ],
                ),
              ),
          ],
        ));
  }

  void addSupportUser() async {
    final UserSupport newUser = UserSupport(
      id: DateTime.now()
          .millisecondsSinceEpoch
          .toString(), // This will be set by the backend
      name: addNameController.text,
      email: addEmailController.text,
      password: addPasswordController.text,
    );

    final success = await supportController.addUser(newUser);
    if (success) {
      clearAddFields();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al crear usuario de soporte')),
      );
    }
  }

  void showEditDialog(BuildContext context, UserSupport user) {
    addNameController.text = user.name;
    addEmailController.text = user.email;
    addPasswordController.text = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Usuario'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildTextField(addNameController, 'Nombre',
                  initialValue: user.name),
              buildTextField(addEmailController, 'Email',
                  initialValue: user.email),
              buildTextField(addPasswordController, 'Contraseña',
                  isPassword: true),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                final updatedUser = user.copyWith(
                  name: addNameController.text,
                  email: addEmailController.text,
                  password: addPasswordController.text.isNotEmpty
                      ? addPasswordController.text
                      : user.password,
                );
                final success = await supportController.updateUser(updatedUser);
                if (success) {
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Error al editar usuario de soporte')),
                  );
                }
              },
              child: const Text('Guardar Cambios'),
            ),
          ],
        );
      },
    );
  }

  Widget buildTextField(TextEditingController controller, String label,
      {bool isPassword = false, String? initialValue}) {
    return TextField(
      controller: controller..text = initialValue ?? '',
      decoration: InputDecoration(labelText: label),
      obscureText: isPassword,
    );
  }

  void clearAddFields() {
    addNameController.clear();
    addEmailController.clear();
    addPasswordController.clear();
  }
}

class ClientManagement extends StatefulWidget {
  const ClientManagement({Key? key}) : super(key: key);

  @override
  _ClientManagementState createState() => _ClientManagementState();
}

class _ClientManagementState extends State<ClientManagement> {
  final TextEditingController addNameController = TextEditingController();
  final TextEditingController editNameController = TextEditingController();
  final ClientController clientController = Get.find<ClientController>();
  Client? selectedClient;

  @override
  void initState() {
    super.initState();
    clientController.getClients();
  }

  Future<void> addClient() async {
    if (addNameController.text.isNotEmpty) {
      bool exists = clientController.clients.any(
          (existingClient) => existingClient.name == addNameController.text);
      if (exists) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cliente ya existe')));
        return;
      }

      Client newClient = Client(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: addNameController.text,
      );
      bool success = await clientController.addClient(newClient);
      addNameController.clear();
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cliente creado exitosamente')));
        setState(() {
          selectedClient = null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al crear cliente')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView(
          padding: const EdgeInsets.all(8.0),
          children: [
            ExpansionTile(
              title: const Text('Agregar Cliente',
                  style: TextStyle(color: Colors.deepPurple)),
              children: [
                buildTextField(addNameController, 'Nombre'),
                ElevatedButton(
                    onPressed: addClient, child: const Text('Guardar Cliente')),
              ],
            ),
            for (var client in clientController.clients)
              ListTile(
                title: Text(client.name),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => showEditDialog(context, client),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        bool success = await clientController
                            .deleteClient(int.parse(client.id));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(success
                                ? 'Cliente borrado exitosamente'
                                : 'Error borrando cliente'),
                          ),
                        );
                        if (success) {
                          setState(() {
                            // Update UI or perform any other necessary actions
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
          ],
        ));
  }

  void showEditDialog(BuildContext context, Client client) {
    editNameController.text = client.name;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Cliente'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildTextField(editNameController, 'Nombre'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                final updatedClient = client.copyWith(
                  name: editNameController.text,
                );
                final success =
                    await clientController.updateClient(updatedClient);
                if (success) {
                  const SnackBar(content: Text('Cliente editado exitosamente'));
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Error al editar el cliente')),
                  );
                }
              },
              child: const Text('Guardar cambios'),
            ),
          ],
        );
      },
    );
  }

  Widget buildTextField(TextEditingController controller, String label,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      obscureText: isPassword,
    );
  }
}

class WorkReportEvaluation extends StatelessWidget {
  WorkReportEvaluation({Key? key}) : super(key: key);

  final ReportController reportController = Get.find<ReportController>();
  final TextEditingController reportIdController = TextEditingController();
  final Rx<Report?> selectedReport = Rx<Report?>(null);
  double _currentRating = 3;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Text(
                'Evaluación de Informes de Trabajo',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              if (reportController.reports
                  .where((report) => !report.revised)
                  .isEmpty)
                const Text(
                  'No hay reportes por revisar',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                )
              else ...[
                DropdownButtonFormField<Report>(
                  isExpanded: true,
                  hint: const Text("Seleccione un Informe"),
                  value: selectedReport.value,
                  items: reportController.reports
                      .where((report) => !report.revised)
                      .map((report) {
                    return DropdownMenuItem<Report>(
                      value: report,
                      child: Text("Report ID: ${report.id}"),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      selectedReport.value = value;
                      _currentRating = value.review.toDouble();
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: 'Informe',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value == null ? 'Seleccione un informe' : null,
                ),
                const SizedBox(height: 16),
                if (selectedReport.value != null) ...[
                  buildReportDetail('Reporte', selectedReport.value!.report),
                  buildReportDetail(
                      'Duración', '${selectedReport.value!.duration} horas'),
                  buildReportDetail(
                      'Cliente', selectedReport.value!.clientName),
                  buildReportDetail(
                      'Fecha y Hora de Inicio',
                      DateFormat('yyyy-MM-dd – kk:mm').format(
                          DateTime.parse(selectedReport.value!.startTime))),
                  buildReportDetail('Usuario de Soporte',
                      selectedReport.value!.supportUser.toString()),
                  const SizedBox(height: 16),
                  const Text(
                    'Evaluación',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: RatingBar.builder(
                      initialRating: _currentRating,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) =>
                          const Icon(Icons.star, color: Colors.amber),
                      onRatingUpdate: (rating) {
                          _currentRating = rating;
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (selectedReport.value != null) {
                        reportController.updateReport(
                            selectedReport.value!.id!, _currentRating.round());
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Revisión enviada!')),
                        );
                        // Clear the selected report after submission
                        selectedReport.value = null;
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Seleccione un informe')),
                        );
                      }
                    },
                    child: const Text('Enviar Revisión'),
                  )
                ]
              ]
            ],
          ),
        ));
  }

  Widget buildReportDetail(String title, String detail) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$title: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(detail),
          ),
        ],
      ),
    );
  }
}

class ReportManagement extends StatefulWidget {
  const ReportManagement({Key? key}) : super(key: key);

  @override
  _ReportManagementState createState() => _ReportManagementState();
}

class _ReportManagementState extends State<ReportManagement> {
  final ReportController reportController = Get.find<ReportController>();
  final ClientController clientController = Get.find<ClientController>();
  Client? selectedClient;

  @override
  void initState() {
    super.initState();
    clientController.getClients();
    reportController.getReports();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          children: [
            Card(
              margin: const EdgeInsets.all(10.0),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButton<Client>(
                        isExpanded: true,
                        value: selectedClient,
                        hint: const Text('Seleccionar un Cliente'),
                        onChanged: (Client? newValue) {
                          setState(() {
                            selectedClient = newValue;
                          });
                        },
                        items: clientController.clients.map((Client client) {
                          return DropdownMenuItem<Client>(
                            value: client,
                            child: Text(client.name),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedClient = null;
                        });
                      },
                      child: const Text('Borrar Filtro'),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: reportController.reports
                    .where((report) =>
                        selectedClient == null ||
                        report.clientName == selectedClient!.name)
                    .map((report) {
                  final formattedDateTime = DateFormat('yyyy-MM-dd – kk:mm')
                      .format(DateTime.parse(
                          report.startTime)); // Format the date and time
                  return Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 10.0),
                    child: ListTile(
                      title: Text('ID de reporte: ${report.id}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Descripcion del problema: ${report.report}'),
                          Text('Calificacion: ${report.review}'),
                          Text('Duracion: ${report.duration} horas'),
                          Text('Hora de inicio: $formattedDateTime'),
                          Text('Nombre del cliente: ${report.clientName}'),
                          Text(
                              'ID de usuario de soporte: ${report.supportUser}'),
                          if (report.revised == false && report.review == 0)
                            const Text(
                              'Debe realizarse revision',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ));
  }
}

class SupportUserStats extends StatelessWidget {
  final SupportController supportController = Get.find<SupportController>();
  final ReportController reportController = Get.find<ReportController>();

  SupportUserStats({Key? key}) : super(key: key) {
    supportController.getUsers();
    reportController.getReports();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final users = supportController.users;
      final reports =
          reportController.reports.where((report) => report.revised).toList();

      return ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          int userId;

          // Ensure user ID is correctly parsed
          try {
            userId = int.parse(user.id);
          } catch (e) {
            return Card(
              margin:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
              child: ListTile(
                title: Text(user.name),
                subtitle: const Text('Error parsing user ID'),
              ),
            );
          }

          final userReports =
              reports.where((report) => report.supportUser == userId).toList();
          final reportCount = userReports.length;
          final averageReview = userReports.isEmpty
              ? 0.0
              : userReports
                      .map((report) => report.review)
                      .reduce((a, b) => a + b) /
                  reportCount;

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            child: ListTile(
              title: Text(user.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Cantidad de reportes: $reportCount'),
                  Text(
                      'Calificacion promedio: ${averageReview.toStringAsFixed(1)}'),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
