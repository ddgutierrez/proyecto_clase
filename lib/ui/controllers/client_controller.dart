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
    bool success = await clientUseCase.addClient(client);
    if (success) {
      getClients(); // Refresh the list to include the new client
    }
    return success; // Return the status for the UI to use
  }

  Future<void> updateClient(Client client) async {
    logInfo("Update client");
    bool success = await clientUseCase.updateClient(client);
    if (success) {
      getClients();
    }
  }

  Future<void> deleteClient(int id) async {
    logInfo("Delete client id $id");
    bool success = await clientUseCase.deleteClient(id);
    if (success) {
      getClients();
    }
  }
}
