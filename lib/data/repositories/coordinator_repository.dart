import '../../domain/models/coordinator.dart';
import '../../domain/repositories/i_coordinator_repository.dart';
import '../datasources/remote/i_coordinator_datasource.dart';

class CoordinatorRepository implements ICoordinatorRepository {
  final ICoordinatorDataSource _coordinatorDataSource;

  CoordinatorRepository(this._coordinatorDataSource);
  @override
  Future<Coordinator?> validateCredentials(String email, String password) async {
    return await _coordinatorDataSource.validateCredentials(email, password);
  }
}