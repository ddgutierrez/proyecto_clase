import '../../../domain/models/client.dart';

abstract class IClientDataSource {
  Future<List<Client>> getClients();

  Future<bool> addClient(Client client);

  Future<bool> updateClient(Client client);

  Future<bool> deleteClient(int id);
}
