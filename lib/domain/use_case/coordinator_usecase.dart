import '../models/coordinator.dart';
import '../repositories/i_coordinator_repository.dart';

class CoordinatorUseCase {
  final ICoordinatorRepository _repository;

  CoordinatorUseCase(this._repository);

  Future<Coordinator?> validateCredentials(String email, String password) async => await _repository.validateCredentials(email, password);
}
