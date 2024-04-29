import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../models/user_support.dart';
import '../controllers/support_controller.dart';
import '../services/api_service_coordinator.dart';
import '../models/client.dart';
// Ensure this import path is correct

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
  final TextEditingController idController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final SupportController supportController = SupportController();

  List<UserSupport> users = []; // List to hold users
  UserSupport? selectedUser; // Currently selected user for editing or deletion

  // Controllers for adding users
  final TextEditingController addNameController = TextEditingController();
  final TextEditingController addEmailController = TextEditingController();
  final TextEditingController addPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadUsers(); // Load users when the widget is initialized
  }

  Future<void> loadUsers() async {
    users = await supportController.apiService.fetchSupportUsers();
    if (users.isNotEmpty) {
      selectedUser = users.first;
      updateFields(); // Update fields based on the selected user
    }
    setState(() {});
  }

  void updateFields() {
    if (selectedUser != null) {
      idController.text = selectedUser!.id;
      nameController.text = selectedUser!.name;
      emailController.text = selectedUser!.email;
      passwordController.text = selectedUser!.password;
    }
  }

  void addSupportUser() async {
    if (addEmailController.text.isNotEmpty &&
        addNameController.text.isNotEmpty &&
        addPasswordController.text.isNotEmpty) {
      try {
        UserSupport newUser = UserSupport(
          id: '',
          name: addNameController.text,
          email: addEmailController.text,
          password: addPasswordController.text,
        );
        await supportController.addSupportUser(newUser);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User added successfully')));
        clearAddFields();
        loadUsers();
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to add user: $e')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all fields')));
    }
  }

  void updateSupportUser() async {
    if (idController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        nameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      Map<String, dynamic> userData = {
        'name': nameController.text,
        'email': emailController.text,
        'password': passwordController.text,
      };
      try {
        await supportController.updateSupportUser(idController.text, userData);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User updated successfully')));
        clearFields();
        loadUsers(); // Reload the list of users
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to update user: $e')));
      }
    }
  }

  void deleteSupportUser() async {
    if (idController.text.isNotEmpty) {
      try {
        await supportController.deleteSupportUser(idController.text);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User deleted successfully')));
        clearFields();
        loadUsers(); // Reload the list of users
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to delete user: $e')));
      }
    }
  }

  void clearFields() {
    idController.clear();
    nameController.clear();
    emailController.clear();
    passwordController.clear();
  }

  void clearAddFields() {
    addNameController.clear();
    addEmailController.clear();
    addPasswordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            'Select a user to edit or delete:',
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(color: Colors.grey.shade300),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<UserSupport>(
              value: selectedUser,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.deepPurple),
              iconSize: 24,
              style: TextStyle(color: Colors.deepPurple[800], fontSize: 16),
              onChanged: (UserSupport? newValue) {
                setState(() {
                  selectedUser = newValue;
                  updateFields();
                });
              },
              items: users.map((UserSupport user) {
                return DropdownMenuItem<UserSupport>(
                  value: user,
                  child: Text(user.name,
                      style: const TextStyle(color: Colors.black87)),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 24),
        ExpansionTile(
          title: const Text('Add User',
              style: TextStyle(color: Colors.deepPurple)),
          childrenPadding: const EdgeInsets.all(8),
          children: [
            TextFormField(
                controller: addNameController,
                decoration: const InputDecoration(labelText: 'Name')),
            TextFormField(
                controller: addEmailController,
                decoration: const InputDecoration(labelText: 'Email')),
            TextFormField(
                controller: addPasswordController,
                decoration: const InputDecoration(labelText: 'Password')),
            ElevatedButton(
                onPressed: addSupportUser, child: const Text('Save User')),
          ],
        ),
        ExpansionTile(
          title: const Text('Edit User',
              style: TextStyle(color: Colors.deepPurple)),
          childrenPadding: const EdgeInsets.all(8),
          children: [
            TextFormField(
                controller: idController,
                decoration: const InputDecoration(labelText: 'ID')),
            TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name')),
            TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email')),
            TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Password')),
            ElevatedButton(
                onPressed: updateSupportUser,
                child: const Text('Save Changes')),
          ],
        ),
        ExpansionTile(
          title: const Text('Delete User',
              style: TextStyle(color: Colors.deepPurple)),
          childrenPadding: const EdgeInsets.all(8),
          children: [
            ElevatedButton(
                onPressed: deleteSupportUser, child: const Text('Delete User')),
          ],
        ),
      ],
    );
  }
}
class ClientManagement extends StatefulWidget {
  const ClientManagement({super.key});

  @override
  _ClientManagementState createState() => _ClientManagementState();
}
class _ClientManagementState extends State<ClientManagement> {
  final TextEditingController addNameController = TextEditingController();
  final TextEditingController editNameController = TextEditingController();
  final TextEditingController editIdController = TextEditingController();
  List<Client> clients = [];
  String? selectedClientId;
  ApiServiceCoordinator apiService = ApiServiceCoordinator();

  @override
  void initState() {
    super.initState();
    fetchClients();
  }
  Future<void> fetchClients() async {
    try {
      clients = await apiService.fetchClients();
      if (clients.isNotEmpty) {
        selectedClientId = clients.first.id.toString();
        editNameController.text = clients.first.name;
        editIdController.text = clients.first.id.toString();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load clients: $e')));
    }
  }
  void addClient() async {
    if (addNameController.text.isNotEmpty) {
      try {
        await apiService.addClient({'name': addNameController.text} as String);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Client added successfully')));
        addNameController.clear();
        fetchClients();  // Refresh the list after adding
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add client: $e')));
      }
    }
  }

  void updateClient() async {
    if (selectedClientId != null && editNameController.text.isNotEmpty) {
      try {
        await apiService.updateClient(selectedClientId!, {'name': editNameController.text} as String);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Client updated successfully')));
        fetchClients();  // Refresh the list after updating
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update client: $e')));
      }
    }
  }

  void deleteClient() async {
    if (selectedClientId != null) {
      try {
        await apiService.deleteClient(selectedClientId!);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Client deleted successfully')));
        fetchClients();  // Refresh the list after deleting
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete client: $e')));
      }
    }
  }
    @override
  Widget build(BuildContext context) {
    return ListView(children: [
      ExpansionTile(
        title: const Text('Add Client'),
        childrenPadding: const EdgeInsets.all(8),
        children: [
          TextFormField(
            controller: addNameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(onPressed: addClient, child: const Text('Save Client')),
        ],
      ),
      if (clients.isNotEmpty) ...[
        ExpansionTile(
          title: const Text('Edit Client'),
          childrenPadding: const EdgeInsets.all(8),
          children: [
            DropdownButton<String>(
              value: selectedClientId,
              onChanged: (value) {
                setState(() {
                  selectedClientId = value;
                  var selectedClient = clients.firstWhere((client) => client.id.toString() == value);
                  editNameController.text = selectedClient.name;
                  editIdController.text = selectedClient.id.toString();
                });
              },
              items: clients.map((client) => DropdownMenuItem<String>(
                value: client.id.toString(),
                child: Text(client.name),
              )).toList(),
            ),
            TextFormField(
              controller: editNameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: updateClient, child: const Text('Save Changes')),
          ],
        ),
        ExpansionTile(
          title: const Text('Delete Client'),
          childrenPadding: const EdgeInsets.all(8),
          children: [
            DropdownButton<String>(
              value: selectedClientId,
              onChanged: (value) {
                setState(() {
                  selectedClientId = value;
                  var selectedClient = clients.firstWhere((client) => client.id.toString() == value);
                  editIdController.text = selectedClient.id.toString();
                });
              },
              items: clients.map((client) => DropdownMenuItem<String>(
                value: client.id.toString(),
                child: Text(client.name),
              )).toList(),
            ),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: deleteClient, child: const Text('Delete Client')),
          ],
        ),
      ],
    ]);
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
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
          onRatingUpdate: (rating) {},
        ))
      ],
    );
  }
}
