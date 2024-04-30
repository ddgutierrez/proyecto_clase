import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:proyecto_clase/domain/models/client.dart';
import '../../domain/models/user_support.dart';
import '../controllers/support_controller.dart';
import '../controllers/client_controller.dart';

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
          return ClientManagement();
        }
      case 1:
        {
          return UserSupportManagement();
        }
      case 2:
        {
          return WorkReportEvaluation();
        }
      default:
        {
          return ClientManagement();
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
                  label: Text('Aministrar Usuarios')),
              NavigationRailDestination(
                  icon: Icon(Icons.support_agent),
                  label: Text('Administrar Usuarios\nde Soporte')),
              NavigationRailDestination(
                  icon: Icon(Icons.rate_review),
                  label: Text('Evaluar Reportes'))
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
                  onPressed: () => supportController.deleteUser(int.parse(user.id)),
                ),
              ],
            ),
          ),
        
        ExpansionTile(
          title: const Text('Add User', style: TextStyle(color: Colors.deepPurple)),
          children: [
            buildTextField(addNameController, 'Name'),
            buildTextField(addEmailController, 'Email'),
            buildTextField(addPasswordController, 'Password', isPassword: true),
            ElevatedButton(
              onPressed: addSupportUser,
              child: const Text('Save User'),
            ),
          ],
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
        const SnackBar(content: Text('Failed to add user')),
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
          title: const Text('Edit User'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildTextField(addNameController, 'Name', initialValue: user.name),
              buildTextField(addEmailController, 'Email', initialValue: user.email),
              buildTextField(addPasswordController, 'Password', isPassword: true),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final updatedUser = user.copyWith(
                  name: addNameController.text,
                  email: addEmailController.text,
                  password: addPasswordController.text.isNotEmpty ? addPasswordController.text : user.password,
                );
                final success = await supportController.updateUser(updatedUser);
                if (success) {
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to update user')),
                  );
                }
              },
              child: const Text('Save Changes'),
            ),
          ],
        );
      },
    );
  }

  Widget buildTextField(TextEditingController controller, String label, {bool isPassword = false, String? initialValue}) {
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
  final ClientController clientController =
      Get.find<ClientController>(); // Assuming GetX for DI
  Client? selectedClient;

  @override
  void initState() {
    super.initState();
    clientController.getClients();
  }

  void addClient() async {
    if (addNameController.text.isNotEmpty) {
      Client newClient = Client(
        id: DateTime.now()
            .millisecondsSinceEpoch
            .toString(), // Assume the ID is generated by the backend
        name: addNameController.text,
      );
      bool success = await clientController.addClient(newClient);
      addNameController
          .clear(); // Clear the input field after the attempt to add
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Client added successfully')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to add client')));
      }
    }
  }

  void updateSelectedClient() async {
    if (selectedClient != null && editNameController.text.isNotEmpty) {
      Client updatedClient = Client(
        id: selectedClient!.id,
        name: editNameController.text,
      );
      await clientController.updateClient(updatedClient);
      // Add success check if needed
      editNameController.clear();
      selectedClient = null; // Clear the selected client after updating
    }
  }

  void deleteSelectedClient() async {
    if (selectedClient != null) {
      await clientController.deleteClient(int.parse(selectedClient!.id));
      selectedClient = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    ClientController clientController = Get.find();
    return Obx(() => ListView(children: [
          ExpansionTile(
            title: const Text('Add Client'),
            childrenPadding: const EdgeInsets.all(8),
            children: [
              TextFormField(
                controller: addNameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                  onPressed: addClient, child: const Text('Save Client')),
            ],
          ),
          if (clientController.clients.isNotEmpty) ...[
            ExpansionTile(
              title: const Text('Edit Client'),
              childrenPadding: const EdgeInsets.all(8),
              children: [
                DropdownButton<Client>(
                  value: selectedClient,
                  onChanged: (Client? newValue) {
                    setState(() {
                      selectedClient = newValue;
                      if (newValue != null) {
                        editNameController.text = newValue.name;
                      }
                    });
                  },
                  items: clientController.clients.map((Client client) {
                    return DropdownMenuItem<Client>(
                      value: client,
                      child: Text(client.name),
                    );
                  }).toList(),
                ),
                TextFormField(
                  controller: editNameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                    onPressed: updateSelectedClient,
                    child: const Text('Update Client')),
              ],
            ),
            ExpansionTile(
              title: const Text('Delete Client'),
              childrenPadding: const EdgeInsets.all(8),
              children: [
                DropdownButton<Client>(
                  value: selectedClient,
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
                const SizedBox(height: 10),
                ElevatedButton(
                    onPressed: deleteSelectedClient,
                    child: const Text('Delete Client')),
              ],
            ),
          ],
        ]));
  }
}

class WorkReportEvaluation extends StatelessWidget {
  const WorkReportEvaluation({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        const Text('Evaluación de Informes de Trabajo',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        TextFormField(
            decoration: const InputDecoration(labelText: 'Id del Informe')),
        Container(
          alignment: Alignment.center,
          child: const Text('Preview del Informe'),
        ),
        const Text('Evaluación',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Center(
            child: RatingBar.builder(
          initialRating: 3,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) =>
              const Icon(Icons.star, color: Colors.amber),
          onRatingUpdate: (rating) {},
        ))
      ],
    );
  }
}
