import '../services/api_service_coordinator.dart';

class ClientController {
  final ApiServiceCoordinator apiServiceClients = ApiServiceCoordinator();

  Future<void> addClient(String name) async {
    await apiServiceClients.addClient({'name': name});
  }

  Future<void> updateClient(String id, String name) async {
    await apiServiceClients.updateClient(id, {'name': name});
  }

  Future<void> deleteClient(String id) async {
    await apiServiceClients.deleteClient(id);
  }
}
