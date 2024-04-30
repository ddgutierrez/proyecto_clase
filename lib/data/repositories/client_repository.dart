import '../../domain/models/client.dart';
import '../../domain/repositories/i_client_repository.dart';
import '../datasources/remote/i_client_datasource.dart';

class ClientRepository implements IClientRepository {
  final IClientDataSource _clientDataSource;

  ClientRepository(this._clientDataSource);

  @override
  Future<List<Client>> getClients() {
    return _clientDataSource.getClients();
  }

  @override
  Future<bool> addClient(Client client) {
    return _clientDataSource.addClient(client);
  }

  @override
  Future<bool> updateClient(Client client) {
    return _clientDataSource.updateClient(client);
  }

  @override
  Future<bool> deleteClient(int id) {
    return _clientDataSource.deleteClient(id);
  }
}