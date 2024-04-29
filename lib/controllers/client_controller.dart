import '../services/api_service_coordinator.dart';

class ClientController {
  final ApiServiceCoordinator apiServiceClients = ApiServiceCoordinator();

  Future<void> addClient(String name) async {
    await apiServiceClients.addClient({'name': name} as String);
  }

  Future<void> updateClient(String id, String name) async {
    await apiServiceClients.updateClient(id, {'name': name} as String);
  }

  Future<void> deleteClient(String id) async {
    await apiServiceClients.deleteClient(id);
  }
}
