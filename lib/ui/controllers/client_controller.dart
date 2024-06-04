import 'package:get/get.dart';
import 'package:loggy/loggy.dart';

import '../../domain/models/client.dart';
import '../../domain/use_case/client_usecase.dart';

class ClientController extends GetxController {
  final RxList<Client> _clients = <Client>[].obs;
  final ClientUseCase clientUseCase = Get.find();

  List<Client> get clients => _clients;

  @override
  void onInit() {
    getClients();
    super.onInit();
  }

  Future<void> getClients() async {
    logInfo("Getting clients");
    _clients.value = await clientUseCase.getClients();
  }

  Future<bool> addClient(Client client) async {
    logInfo("Add client");
    // Check for duplicates before adding
    bool exists =
        _clients.any((existingClient) => existingClient.name == client.name);
    if (exists) {
      logInfo("Client with the same name already exists");
      return false; // Indicate that the client already exists
    }

    bool success = await clientUseCase.addClient(client);
    if (success) {
      getClients(); // Refresh the list to include the new client
    }
    return success; // Return the status for the UI to use
  }

  Future<bool> updateClient(Client client) async {
    logInfo("Update client");
    bool success = await clientUseCase.updateClient(client);
    if (success) {
      await getClients(); // Ensure to await the getClients call
    }
    return success; // Return the success status
  }

  Future<bool> deleteClient(int id) async {
    logInfo("Delete client id $id");
    bool success = await clientUseCase.deleteClient(id);
    if (success) {
      getClients();
    }
    return success;
  }
}
