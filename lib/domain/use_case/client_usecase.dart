import 'package:loggy/loggy.dart';

import '../models/client.dart';
import '../repositories/i_client_repository.dart';

class ClientUseCase {
  final IClientRepository _repository;

  ClientUseCase(this._repository);

  Future<List<Client>> getClients() async => await _repository.getClients();

  Future<bool> addClient(Client client) async {
  try {
    return await _repository.addClient(client);
  } catch (e) {
    logError('Failed to add client', e);
    return false;
  }
}

  Future<bool> updateClient(Client client) async => await _repository.updateClient(client);

  Future<bool> deleteClient(int id) async => await _repository.deleteClient(id);
}
